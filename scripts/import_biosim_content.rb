#!/usr/bin/env ruby

require "cgi"
require "date"
require "fileutils"
require "net/http"
require "nokogiri"
require "set"
require "uri"
require "yaml"

ROOT = File.expand_path("..", __dir__)
BASE = "https://www.biosim.ntua.gr"

def fetch(path)
  uri = URI(path.start_with?("http") ? path : "#{BASE}#{path}")
  response = Net::HTTP.get_response(uri)
  raise "#{uri} returned #{response.code}" unless response.is_a?(Net::HTTPSuccess)
  response.body
end

def doc(path)
  Nokogiri::HTML(fetch(path))
end

def yaml_string(value)
  value.to_s.gsub("\\", "\\\\").gsub('"', '\\"')
end

def slugify(value)
  value.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")[0, 80].gsub(/-$/, "")
end

def clean_text(value)
  CGI.unescapeHTML(value.to_s).gsub(/\s+/, " ").strip
end

def absolute_url(href)
  return nil if href.nil? || href.empty? || href.start_with?("#", "mailto:", "javascript:")
  return href if href.start_with?("http")

  "#{BASE}#{href.start_with?("/") ? href : "/#{href}"}"
end

def inline_markdown(node)
  node.children.map do |child|
    case child.name
    when "text"
      CGI.unescapeHTML(child.text).gsub(/\s+/, " ")
    when "a"
      text = clean_text(child.text)
      href = absolute_url(child["href"])
      href && !text.empty? ? "[#{text}](#{href})" : text
    when "strong", "b"
      text = inline_markdown(child).strip
      text.empty? ? nil : "**#{text}**"
    when "em", "i"
      text = inline_markdown(child).strip
      text.empty? ? nil : "_#{text}_"
    when "br"
      "\n"
    when "img", "script", "style"
      nil
    else
      inline_markdown(child)
    end
  end.compact.join.gsub(/[ \t]+\n/, "\n").gsub(/\n[ \t]+/, "\n").strip
end

def block_markdown(node)
  case node.name
  when "p", "h3", "h4", "h5", "h6"
    inline_markdown(node)
  when "ul", "ol"
    node.css("li").map { |li| text = inline_markdown(li); text.empty? ? nil : "- #{text}" }.compact.join("\n")
  when "div"
    block_children = node.children.select { |child| %w[p ul ol h3 h4 h5 h6].include?(child.name) }
    return block_children.map { |child| block_markdown(child) }.reject(&:empty?).join("\n\n") unless block_children.empty?

    inline_markdown(node)
  else
    ""
  end
end

def content_heading(news_doc)
  news_doc.css("article h2, .tm-content h2, main h2, h2").find { |node| clean_text(node.text).length > 10 }
end

def detail_content(news_doc)
  h2 = content_heading(news_doc)
  return [nil, nil] unless h2

  image = news_doc.css("article img, .tm-content img, img").map { |img| img["src"] }.find { |src| src && !src.include?("/themes/biosim/assets/img/biosim.png") }
  image ||= news_doc.css("meta[property='og:image'], meta[name='twitter:image']").map { |meta| meta["content"] }.find { |src| src && !src.include?("/themes/biosim/assets/img/biosim.png") }
  image ||= news_doc.to_html[/url\(['"]?([^)'"]+\.(?:png|jpe?g|gif|webp))['"]?\)/i, 1]
  blocks = []
  node = h2.next_element
  while node
    if %w[p div ul ol].include?(node.name)
      text = block_markdown(node)
      break if clean_text(text).start_with?("Copyright")
      blocks << text unless text.empty?
    end
    node = node.next_element
  end
  [image, blocks.join("\n\n")]
end

def detail_title_from_html(html, fallback)
  match = html.match(/<!--\s*<li class="uk-active">(.*?)<\/li>\s*-->/m)
  doc = Nokogiri::HTML(html)

  candidates = []
  candidates << clean_text(match && Nokogiri::HTML.fragment(match[1]).text)
  candidates.concat(doc.css("article h2, .tm-content h2, main h2, h2").map { |node| clean_text(node.text) })
  candidates.concat(doc.css("meta[property='og:title'], meta[name='twitter:title']").map { |meta| clean_text(meta["content"]) })
  candidates << clean_text(doc.at_css("title")&.text).sub(/\s*•\s*BioSim\z/, "")
  title = candidates.reject(&:empty?).max_by(&:length)
  title.nil? || title.empty? ? fallback : title
end

def download_news_image(source, slug)
  return nil if source.nil? || source.empty?
  uri = URI(source.start_with?("http") ? source : "#{BASE}#{source}")
  ext = File.extname(uri.path)
  ext = ".jpg" if ext.empty?
  local_dir = File.join(ROOT, "assets", "img", "news")
  FileUtils.mkdir_p(local_dir)
  local_path = File.join(local_dir, "#{slug}#{ext}")
  File.binwrite(local_path, Net::HTTP.get(uri))
  "/assets/img/news/#{File.basename(local_path)}"
rescue StandardError => e
  warn "image download failed for #{source}: #{e.message}"
  nil
end

def import_news
  items = []
  seen = Set.new
  teaser_images = {}
  teaser_titles = {}
  teaser_titles_el = {}
  begin
    doc("/en").css("a[href^='/news/']").each do |link|
      next unless link["href"] =~ %r{\A/news/\d+\z}
      image = link.css("img").first || link.ancestors.flat_map { |ancestor| ancestor.css("img") }.first
      teaser_images[link["href"]] ||= image&.[]("src")
      teaser_text = clean_text(link.text)
      teaser_titles[link["href"]] ||= teaser_text if teaser_text.length > 10 && teaser_text != "Read more..."
    end
    doc("/gr").css("a[href^='/news/']").each do |link|
      next unless link["href"] =~ %r{\A/news/\d+\z}
      teaser_text = clean_text(link.text)
      teaser_titles_el[link["href"]] ||= teaser_text if teaser_text.length > 10 && teaser_text != "Περισσότερα..." && teaser_text != "Read more..."
    end
  rescue StandardError => e
    warn "homepage teaser image scan failed: #{e.message}"
  end

  (1..11).each do |page|
    path = page == 1 ? "/en/news" : "/en/news?page=#{page}"
    listing = doc(path)
    listing.css("dl.uk-description-list-horizontal dd").each do |dd|
      link = dd.at_css("a[href^='/news/']")
      next unless link
      href = link["href"]
      next unless href =~ %r{\A/news/\d+\z}
      next if seen.include?(href)
      seen << href

      preview_title = clean_text(link.text)
      next if preview_title.empty?
      date_text = clean_text(dd.previous_element&.text)
      date = Date.strptime(date_text, "%d/%m/%Y") rescue Date.today

      en_html = fetch("/en#{href}") rescue nil
      el_html = fetch("/gr#{href}") rescue nil
      en_detail = en_html ? Nokogiri::HTML(en_html) : nil
      el_detail = el_html ? Nokogiri::HTML(el_html) : nil
      title = en_html ? detail_title_from_html(en_html, preview_title) : preview_title
      image_source, content_en = en_detail ? detail_content(en_detail) : [nil, title]
      image_source ||= teaser_images[href]
      _image_source_el, content_el = el_detail ? detail_content(el_detail) : [nil, nil]
      title_el = el_html ? detail_title_from_html(el_html, nil) : nil
      title_el = nil if title_el.empty? || title_el == title
      content_el = nil unless content_el.to_s.match?(/[Α-Ωα-ω]/)
      title_el = nil unless content_el
      short_title_el = content_el ? teaser_titles_el[href] : nil

      slug = slugify(title)
      image = download_news_image(image_source, slug)
      items << {
        source_url: "#{BASE}/en#{href}",
        date: date,
        slug: slug,
        title: title,
        short_title: teaser_titles[href] || preview_title,
        title_el: title_el,
        short_title_el: short_title_el,
        image: image,
        content_en: content_en.nil? || content_en.empty? ? title : content_en,
        content_el: content_el.nil? || content_el.empty? ? nil : content_el,
      }
    end
  end

  news_dir = File.join(ROOT, "_news")
  FileUtils.mkdir_p(news_dir)
  Dir[File.join(news_dir, "*.md")].each { |file| File.delete(file) }

  items.sort_by { |item| [-item[:date].jd, item[:slug]] }.each_with_index do |item, index|
    filename = File.join(news_dir, format("%03d-%s.md", index + 1, item[:slug]))
    body = []
    body << "---"
    body << "layout: post"
    body << "title: \"#{yaml_string(item[:title])}\""
    body << "short_title: \"#{yaml_string(item[:short_title])}\"" if item[:short_title]
    body << "title_el: \"#{yaml_string(item[:title_el])}\"" if item[:title_el]
    body << "short_title_el: \"#{yaml_string(item[:short_title_el])}\"" if item[:short_title_el]
    body << "date: #{item[:date].strftime("%Y-%m-%d")}"
    body << "source_url: #{item[:source_url]}"
    body << "image: #{item[:image]}" if item[:image]
    if item[:content_el]
      body << "summary_el: \"#{yaml_string(item[:content_el].split("\n").first[0, 220])}\""
      body << "content_el: |"
      item[:content_el].split("\n").each { |line| body << "  #{line}" }
    end
    body << "---"
    body << ""
    body << item[:content_en]
    body << ""
    File.write(filename, body.join("\n"))
  end

  puts "Imported #{items.length} news posts"
end

def bib_escape(value)
  value.to_s.gsub(/\\+&/, "&").gsub("\\", " ").gsub("{", "\\{").gsub("}", "\\}").gsub("&", "\\&")
end

def bib_key(title, year, id)
  base = slugify(title).split("-").first(5).join("")
  "biosim#{year}#{base}#{id}"
end

def publication_type(pub)
  classes = pub["class"].to_s.split
  return "article" if classes.include?("article")
  return "book" if classes.include?("book")
  return "incollection" if classes.include?("inbook")
  return "inproceedings" if classes.include?("conference")

  "misc"
end

def bib_field(name, value)
  return nil if value.nil? || value.to_s.empty?

  "  #{name} = {#{bib_escape(value)}}"
end

def import_publications
  entries = []
  seen = Set.new

  (1..80).each do |page|
    publication_doc = doc("/en/publications?type=all&page=#{page}") rescue nil
    break unless publication_doc

    pubs = publication_doc.css("div.publication")
    break if pubs.empty? && page > 1

    pubs.each do |pub|
      link = pub.at_css("a[href^='/publication/']")
      next unless link && link["href"] =~ %r{\A/publication/(\d+)\z}

      id = Regexp.last_match(1)
      next if seen.include?(id)
      seen << id

      title = clean_text(link.text)
      next if title.empty?

      authors = pub.css("a[href^='/publications?author=']").map { |author| clean_text(author.text) }.reject(&:empty?).uniq
      authors = ["BIOSIM Laboratory"] if authors.empty?
      year = clean_text(pub.at_css("span.year")&.text)
      year = clean_text(pub.text)[/\b(19|20)\d{2}\b/] if year.empty?
      venue = clean_text(pub.at_css("em")&.text)
      citation = clean_text(pub.text)
      volume = citation[/\bvol\.\s*([^,\.]+)/i, 1]
      pages = citation[/\bpp\.\s*([^,\.]+(?:--?[^,\.]+)?)/i, 1]
      pages = nil if pages.to_s.strip == "-"
      type = publication_type(pub)

      entries << {
        id: id,
        type: type,
        key: bib_key(title, year, id),
        title: title,
        authors: authors.join(" and "),
        year: year,
        venue: venue,
        volume: volume,
        pages: pages,
        url: "#{BASE}/en/publication/#{id}",
      }
    end
  end

  bibliography = File.join(ROOT, "_bibliography", "papers.bib")
  FileUtils.mkdir_p(File.dirname(bibliography))
  File.write(bibliography, entries.sort_by { |entry| [-entry[:year].to_i, -entry[:id].to_i] }.map { |entry|
    venue_field = case entry[:type]
                  when "article" then "journal"
                  when "inproceedings" then "booktitle"
                  when "incollection" then "booktitle"
                  else "publisher"
                  end
    fields = [
      bib_field("title", entry[:title]),
      bib_field("author", entry[:authors]),
      bib_field("year", entry[:year]),
      bib_field(venue_field, entry[:venue]),
      bib_field("volume", entry[:volume]),
      bib_field("pages", entry[:pages]),
      bib_field("url", entry[:url]),
    ].compact

    "@#{entry[:type]}{#{entry[:key]},\n#{fields.join(",\n")}\n}\n"
  }.join("\n"))

  puts "Imported #{entries.length} publications"
end

def thesis_entry(li)
  link = li.at_css("a")
  text = clean_text(li.text)
  return nil if text.empty?

  title = clean_text(link&.text)
  author = title.empty? ? text : clean_text(text.split(title, 2).first.gsub(/,\s*\z/, ""))
  details = title.empty? ? nil : clean_text(text.split(title, 2).last.gsub(/\A\s*,\s*/, ""))
  {
    "author" => author,
    "title" => title.empty? ? text : title,
    "url" => link && URI.join(BASE, link["href"].to_s.strip).to_s,
    "details" => details,
  }.compact
end

def merge_localized_entries(en_entries, el_entries)
  en_entries.each_with_index.map do |entry, index|
    localized = el_entries[index] || {}
    {
      "author_en" => entry["author"],
      "author_el" => localized["author"] || entry["author"],
      "title_en" => entry["title"],
      "title_el" => localized["title"] || entry["title"],
      "url" => entry["url"],
      "details_en" => entry["details"],
      "details_el" => localized["details"] || entry["details"],
    }.compact
  end
end

def diploma_theses(locale)
  grouped = Hash.new { |hash, key| hash[key] = [] }
  (1..6).each do |page|
    path = "/#{locale}/research/thesis"
    path = "#{path}?page=#{page}" if page > 1
    thesis_doc = doc(path) rescue nil
    next unless thesis_doc

    year = nil
    thesis_doc.css("h2, li").each do |node|
      if node.name == "h2"
        year_text = clean_text(node.text)
        year = year_text if year_text.match?(/\A\d{4}\z/)
      elsif year
        entry = thesis_entry(node)
        grouped[year] << entry if entry && entry["title"].length > 8
      end
    end
  end
  grouped.sort_by { |year, _entries| -year.to_i }.map { |year, entries| { "year" => year.to_i, "entries" => entries } }
end

def phd_theses(locale)
  thesis_doc = doc("/#{locale}/research/phds")
  thesis_doc.css("h1").first&.xpath("following-sibling::ul[1]/li")&.map { |li| thesis_entry(li) }&.compact || []
end

def import_theses
  data_dir = File.join(ROOT, "_data")
  FileUtils.mkdir_p(data_dir)
  File.write(File.join(data_dir, "diploma_theses.yml"), diploma_theses("en").to_yaml)
  File.write(File.join(data_dir, "phd_theses.yml"), merge_localized_entries(phd_theses("en"), phd_theses("gr")).to_yaml)
  puts "Imported diploma and PhD theses"
end

def localize_data_images(file, folder, name_key)
  path = File.join(ROOT, file)
  return unless File.exist?(path)

  data = YAML.load_file(path)
  local_dir = File.join(ROOT, "assets", "img", folder)
  FileUtils.mkdir_p(local_dir)

  changed = false
  data.each_with_index do |item, index|
    source = item["image"]
    next unless source.to_s.start_with?("http")

    uri = URI(source)
    ext = File.extname(uri.path)
    ext = ".jpg" if ext.empty?
    basename = slugify(item[name_key] || item["title_en"] || item["name_en"] || "image-#{index + 1}")
    local_path = File.join(local_dir, "#{basename}#{ext}")
    File.binwrite(local_path, Net::HTTP.get(uri))
    item["image"] = "/assets/img/#{folder}/#{File.basename(local_path)}"
    changed = true
  rescue StandardError => e
    warn "data image download failed for #{source}: #{e.message}"
  end

  File.write(path, data.to_yaml) if changed
end

tasks = ARGV.empty? ? %w[news publications images theses] : ARGV
import_news if tasks.include?("news")
import_publications if tasks.include?("publications")
if tasks.include?("images")
  localize_data_images("_data/members.yml", "people", "name_en")
  localize_data_images("_data/projects.yml", "projects", "title_en")
end
import_theses if tasks.include?("theses")
