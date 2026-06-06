#!/usr/bin/env ruby

require "cgi"
require "fileutils"
require "net/http"
require "nokogiri"
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

def clean_text(value)
  CGI.unescapeHTML(value.to_s).gsub(/\s+/, " ").strip
end

def slugify(value)
  value.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")[0, 80].gsub(/-$/, "")
end

def inline_markdown(node)
  node.children.map do |child|
    case child.name
    when "text"
      CGI.unescapeHTML(child.text).gsub(/\s+/, " ")
    when "a"
      text = clean_text(child.text)
      text.empty? ? nil : "[#{text}](#{child['href']})"
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
  when "p"
    inline_markdown(node)
  when "h3", "h4", "h5", "h6"
    prefix = "#" * node.name[1..].to_i
    "#{prefix} #{inline_markdown(node)}"
  when "ul", "ol"
    node.css("li").map { |li| "- #{inline_markdown(li)}" }.join("\n")
  when "div"
    block_children = node.children.select { |child| %w[p ul ol h3 h4 h5 h6].include?(child.name) }
    return block_children.map { |child| block_markdown(child) }.reject(&:empty?).join("\n\n") unless block_children.empty?
    inline_markdown(node)
  else
    ""
  end
end

def html_to_markdown(div)
  blocks = []
  div.children.each do |child|
    next unless %w[p div ul ol h3 h4 h5 h6].include?(child.name)
    text = block_markdown(child)
    next if text.empty?
    blocks << text
  end
  blocks.join("\n\n")
end

people_html = fetch("/en/people")
people_doc = Nokogiri::HTML(people_html)
old_slugs = people_doc.css("a[href^='/people/']").map { |link|
  href = link["href"]
  next if href == "/people" || href == "/people/"
  href.split("/").last
}.compact.uniq

puts "Found #{old_slugs.length} old slugs"

name_to_slug = {}
old_slugs.each do |slug|
  html = fetch("/en/people/#{slug}")
  doc = Nokogiri::HTML(html)
  h2 = doc.at_css(".uk-panel-box h2")
  next unless h2
  name = clean_text(h2.text)
  name_to_slug[name] = slug
end

puts "Mapped #{name_to_slug.length} names to slugs"

members_path = File.join(ROOT, "_data", "members.yml")
members = YAML.load_file(members_path)

people_dir = File.join(ROOT, "_people")
FileUtils.mkdir_p(people_dir)

# Remove existing generated files
Dir[File.join(people_dir, "*.md")].each { |f| File.delete(f) }

count = 0
members.each do |member|
  name_en = member["name_en"]
  old_slug = name_to_slug[name_en]

  unless old_slug
    puts "WARN: No old slug for '#{name_en}'"
    next
  end

  en_html = fetch("/en/people/#{old_slug}")
  gr_html = fetch("/gr/people/#{old_slug}")

  en_doc = Nokogiri::HTML(en_html)
  gr_doc = Nokogiri::HTML(gr_html)

  panel = en_doc.at_css(".uk-panel-box")
  email_a = en_doc.at_css("a[href^='mailto:']")
  email = email_a&.[]("href")&.sub("mailto:", "")

  room = nil
  panel&.css("p").each do |p|
    text = clean_text(p.text)
    room = text if text =~ /\A[\d]+[\.\d]*\z/
  end

  en_content_div = en_doc.at_css(".uk-width-medium-7-8")
  en_content = en_content_div ? html_to_markdown(en_content_div) : ""

  gr_content_div = gr_doc.at_css(".uk-width-medium-7-8")
  gr_content = gr_content_div ? html_to_markdown(gr_content_div) : ""
  gr_content = nil if gr_content.to_s.strip.empty?

  clean_slug = slugify(name_en)

  content = []
  content << "---"
  content << "layout: person"
  content << "title: #{name_en.inspect}"
  content << "name_el: #{member['name_el'].inspect}"
  content << "role: #{member['role_en'].inspect}"
  content << "role_el: #{member['role_el'].inspect}"
  content << "email: #{email.inspect}" if email && !email.empty?
  content << "room: #{room.inspect}" if room && !room.empty?
  content << "image: #{member['image'].inspect}" if member['image'] && !member['image'].empty?
  content << "category: #{member['category'].inspect}"
  if gr_content
    content << "content_el: |"
    gr_content.split("\n").each { |line| content << "  #{line}" }
  end
  content << "---"
  content << ""
  content << en_content unless en_content.empty?
  content << ""

  filename = File.join(people_dir, "#{clean_slug}.md")
  File.write(filename, content.join("\n"))
  puts "  #{filename}"
  count += 1
end

puts "\nGenerated #{count} profile pages"
