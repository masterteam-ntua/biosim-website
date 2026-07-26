#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "optparse"
require "open3"
require "pathname"

ROOT = Pathname.new(__dir__).join("..").expand_path
IMAGE_DIRS = %w[
  assets/img/news
  assets/img/people
  assets/img/projects
  assets/img/uploads
].freeze
SOURCE_DIRS = %w[_news _people _projects _data _pages].freeze
SOURCE_FILES = ["admin/config.yml"].freeze
IMAGE_EXTENSIONS = %w[.jpg .jpeg .png].freeze
TEXT_EXTENSIONS = %w[.md .markdown .html .liquid .yml .yaml .json .js .scss .css .toml .txt].freeze
SKIP_PATTERN = /(logo|brand|favicon)/i

options = {
  dry_run: false,
  delete_originals: true,
  quality: 82,
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby scripts/convert_images_to_webp.rb [options]"
  opts.on("--dry-run", "Report planned conversions/references without writing files") { options[:dry_run] = true }
  opts.on("--keep-originals", "Keep JPG/PNG originals after successful conversion") { options[:delete_originals] = false }
  opts.on("--quality QUALITY", Integer, "cwebp quality, 0-100 (default: 82)") { |value| options[:quality] = value }
end.parse!

def image_file?(path)
  IMAGE_EXTENSIONS.include?(path.extname.downcase)
end

def skipped_image?(path)
  path.basename.to_s.match?(SKIP_PATTERN)
end

def cwebp_available?
  system("cwebp", "-version", out: File::NULL, err: File::NULL)
end

def source_files
  files = SOURCE_DIRS.flat_map do |dir|
    root = ROOT.join(dir)
    next [] unless root.directory?

    root.find.select { |path| path.file? && TEXT_EXTENSIONS.include?(path.extname.downcase) }
  end

  SOURCE_FILES.each do |file|
    path = ROOT.join(file)
    files << path if path.file?
  end

  files.uniq
end

def replace_references!(replacements, dry_run:)
  changed = []

  source_files.each do |file|
    original = file.read
    updated = replacements.reduce(original) do |content, (from, to)|
      content.gsub(from, to)
    end

    next if updated == original

    changed << file.relative_path_from(ROOT).to_s
    file.write(updated) unless dry_run
  end

  changed
end

images = IMAGE_DIRS.flat_map do |dir|
  root = ROOT.join(dir)
  next [] unless root.directory?

  root.find.select { |path| path.file? && image_file?(path) && !skipped_image?(path) }
end

if images.empty?
  puts "No JPG/PNG images found for WebP conversion."
  exit 0
end

needs_cwebp = images.any? { |path| !path.sub_ext(".webp").file? }
abort "cwebp is required. Install the webp package and retry." if needs_cwebp && !options[:dry_run] && !cwebp_available?

converted = []
deleted = []
failed = []
replacements = {}

images.each do |image|
  webp = image.sub_ext(".webp")
  rel_image = image.relative_path_from(ROOT).to_s
  rel_webp = webp.relative_path_from(ROOT).to_s

  replacements[rel_image] = rel_webp
  replacements["/#{rel_image}"] = "/#{rel_webp}"

  if options[:dry_run]
    converted << "#{rel_image} -> #{rel_webp}" unless webp.file?
  elsif !webp.file?
    stdout, stderr, status = Open3.capture3("cwebp", "-quiet", "-q", options[:quality].to_s, image.to_s, "-o", webp.to_s)
    if status.success? && webp.file?
      converted << "#{rel_image} -> #{rel_webp}"
    else
      failed << "#{rel_image}: #{stderr.strip.empty? ? stdout.strip : stderr.strip}"
      replacements.delete(rel_image)
      replacements.delete("/#{rel_image}")
      next
    end
  end

  next unless options[:delete_originals]
  next unless options[:dry_run] || webp.file?

  deleted << rel_image
  FileUtils.rm_f(image) unless options[:dry_run]
end

changed_sources = replace_references!(replacements, dry_run: options[:dry_run])

puts "Converted: #{converted.size}"
converted.each { |line| puts "  #{line}" }
puts "Rewritten source files: #{changed_sources.size}"
changed_sources.each { |line| puts "  #{line}" }
puts "Deleted originals: #{deleted.size}"
deleted.each { |line| puts "  #{line}" }

unless failed.empty?
  warn "Failed conversions: #{failed.size}"
  failed.each { |line| warn "  #{line}" }
  exit 1
end
