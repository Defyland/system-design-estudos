#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "set"
require "yaml"

ROOT = Pathname(__dir__).join("..").expand_path
CURRICULUM = YAML.safe_load(ROOT.join("curriculum.yml").read, aliases: true)

@errors = []

def error(message)
  @errors << message
end

def assert(condition, message)
  error(message) unless condition
end

def exists?(relative_path)
  ROOT.join(relative_path).exist?
end

def relative_link(from_file, target_path)
  ROOT.join(target_path).relative_path_from(ROOT.join(from_file).dirname).to_s
end

chapters = CURRICULUM.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }
areas = CURRICULUM.fetch("areas")
area_ids = areas.map { |area| area.fetch("id") }.to_set
area_by_id = areas.to_h { |area| [ area.fetch("id"), area ] }
phase_ids = CURRICULUM.fetch("phases").map { |phase| phase.fetch("id") }.to_set
phase_chapter_ids = CURRICULUM.fetch("phases").flat_map { |phase| phase.fetch("chapters") }

assert(CURRICULUM.fetch("version") >= 2, "curriculum.yml must be version 2 or newer")
assert(chapters.map { |chapter| chapter.fetch("id") }.uniq.size == chapters.size, "chapter ids must be unique")
assert(chapters.map { |chapter| chapter.fetch("slug") }.uniq.size == chapters.size, "chapter slugs must be unique")
assert(chapters.map { |chapter| chapter.fetch("number") } == (1..chapters.size).to_a, "chapter numbers must be sequential")
assert(phase_chapter_ids == chapters.map { |chapter| chapter.fetch("id") }, "phase chapter order must match canonical chapter order")

areas.each do |area|
  area.fetch("content_dirs").each_value do |path|
    assert(exists?(path), "area path missing: #{path}")
  end
end

chapters.each do |chapter|
  number = chapter.fetch("number")
  title = chapter.fetch("title")
  chapter_path = chapter.fetch("path")
  lab_path = chapter.fetch("lab").fetch("path")
  review_path = chapter.fetch("review_card").fetch("path")

  assert(phase_ids.include?(chapter.fetch("phase")), "unknown phase for chapter #{number}")
  assert(area_ids.include?(chapter.fetch("primary_area")), "unknown primary area for chapter #{number}")
  chapter.fetch("secondary_areas").each do |area_id|
    assert(area_ids.include?(area_id), "unknown secondary area #{area_id} for chapter #{number}")
  end

  [
    chapter_path,
    lab_path,
    review_path,
    chapter.fetch("suggested_contrast").fetch("path"),
    chapter.fetch("primary_case").fetch("path"),
    *chapter.fetch("complementary_cases").map { |case_ref| case_ref.fetch("path") },
    *chapter.fetch("notes")
  ].each do |path|
    assert(exists?(path), "chapter #{number} references missing path: #{path}")
  end

  next unless exists?(chapter_path)

  body = ROOT.join(chapter_path).read
  assert(body.include?("# Chapter %02d - #{title}" % number), "chapter #{number} H1 does not match manifest title")
  assert(body.include?("## Study Context"), "chapter #{number} missing Study Context")

  [
    lab_path,
    review_path,
    chapter.fetch("suggested_contrast").fetch("path"),
    chapter.fetch("primary_case").fetch("path"),
    *chapter.fetch("complementary_cases").map { |case_ref| case_ref.fetch("path") },
    area_by_id.fetch(chapter.fetch("primary_area")).fetch("content_dirs").fetch("readme"),
    *chapter.fetch("secondary_areas").map { |area_id| area_by_id.fetch(area_id).fetch("content_dirs").fetch("readme") }
  ].each do |target_path|
    assert(body.include?(relative_link(chapter_path, target_path)), "chapter #{number} Study Context missing link to #{target_path}")
  end

  if exists?(lab_path)
    assert(ROOT.join(lab_path).read.include?("# Lab - Chapter %02d" % number), "lab H1 mismatch for chapter #{number}")
  end

  if exists?(review_path)
    assert(ROOT.join(review_path).read.include?("# Review Card %02d - #{title}" % number), "review card H1 mismatch for chapter #{number}")
  end
end

markdown_link_pattern = /\[[^\]]+\]\(([^)]+)\)/
Dir.glob(ROOT.join("**/*.md")).each do |file|
  path = Pathname(file)
  path.read.scan(markdown_link_pattern).flatten.each do |target|
    next if target.start_with?("http://", "https://", "mailto:", "#")
    next if target.empty?

    clean_target = target.split("#", 2).first
    next if clean_target.empty?

    target_path = path.dirname.join(clean_target).cleanpath
    assert(target_path.exist?, "broken markdown link in #{path.relative_path_from(ROOT)}: #{target}")
  end
end

if @errors.any?
  puts @errors.map { |message| "- #{message}" }
  exit 1
end

puts "curriculum OK: #{chapters.size} chapters, #{areas.size} areas"
