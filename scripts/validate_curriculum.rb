#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "rbconfig"
require "set"
require "yaml"

ROOT = Pathname(__dir__).join("..").expand_path
CURRICULUM = YAML.safe_load(ROOT.join("curriculum.yml").read, aliases: true)
CARD_SECTION_CONTRACTS = {
  "backend_principle_catalog" => [
    "When to Use",
    "What Breaks First",
    "Interview Trap",
    "Practice Drill",
    "Source Anchor"
  ],
  "engineering_case_study_catalog" => [
    "Case Pattern",
    "When to Use",
    "What Breaks First",
    "Interview Trap",
    "Practice Drill",
    "Source Anchor"
  ]
}.freeze

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

def markdown_cards(path)
  ROOT.join(path).children.select { |card| card.file? && card.extname == ".md" }.sort
end

def source_anchor_body(body)
  body[/^## Source Anchor\s*$(.*?)(?=^## |\z)/m, 1]
end

def markdown_links(body)
  body.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten
end

def local_link?(target)
  !target.start_with?("http://", "https://", "mailto:", "#") && !target.empty?
end

def clean_local_target(target)
  target.split("#", 2).first
end

def validate_card_contract(area)
  required_sections = CARD_SECTION_CONTRACTS[area.fetch("kind")]
  return unless required_sections

  cards_dir = area.fetch("content_dirs").fetch("cards", nil)
  unless cards_dir
    error("area #{area.fetch("id")} missing cards content dir")
    return
  end

  cards_path = ROOT.join(cards_dir)
  assert(cards_path.directory?, "area #{area.fetch("id")} cards path is not a directory: #{cards_dir}")
  return unless cards_path.directory?

  cards = markdown_cards(cards_dir)
  assert(cards.any?, "area #{area.fetch("id")} has no markdown cards: #{cards_dir}")
  validate_area_readme_cards(area, cards)

  cards.each do |card|
    body = card.read
    relative_path = card.relative_path_from(ROOT)
    h1_count = body.scan(/^# [^\n]+$/).size

    assert(h1_count == 1, "card #{relative_path} must have exactly one H1")

    required_sections.each do |section|
      assert(body.match?(/^## #{Regexp.escape(section)}\s*$/), "card #{relative_path} missing section: #{section}")
    end

    anchor_body = source_anchor_body(body)
    next unless anchor_body

    assert(
      anchor_body.match?(/\[[^\]]+\]\(https?:\/\/[^)]+\)/),
      "card #{relative_path} Source Anchor must include at least one http link"
    )
  end
end

def validate_area_readme_cards(area, cards)
  readme_path = ROOT.join(area.fetch("content_dirs").fetch("readme"))
  readme_body = readme_path.read
  listed_card_paths = markdown_links(readme_body)
    .map { |target| clean_local_target(target) }
    .select { |target| target.start_with?("./cards/") && target.end_with?(".md") }
    .map { |target| readme_path.dirname.join(target).cleanpath.relative_path_from(ROOT).to_s }
    .sort
  actual_card_paths = cards.map { |card| card.relative_path_from(ROOT).to_s }.sort

  missing = actual_card_paths - listed_card_paths
  extra = listed_card_paths - actual_card_paths

  assert(missing.empty?, "area #{area.fetch("id")} README missing cards: #{missing.join(", ")}")
  assert(extra.empty?, "area #{area.fetch("id")} README lists unknown cards: #{extra.join(", ")}")
end

def validate_area_paths(areas)
  areas.each do |area|
    area.fetch("content_dirs").each_value do |path|
      assert(exists?(path), "area path missing: #{path}")
    end

    validate_card_contract(area)
  end
end

def validate_manifest_shape(chapters, phase_chapter_ids)
  assert(CURRICULUM.fetch("version") >= 2, "curriculum.yml must be version 2 or newer")
  assert(chapters.map { |chapter| chapter.fetch("id") }.uniq.size == chapters.size, "chapter ids must be unique")
  assert(chapters.map { |chapter| chapter.fetch("slug") }.uniq.size == chapters.size, "chapter slugs must be unique")
  assert(chapters.map { |chapter| chapter.fetch("number") } == (1..chapters.size).to_a, "chapter numbers must be sequential")
  assert(phase_chapter_ids == chapters.map { |chapter| chapter.fetch("id") }, "phase chapter order must match canonical chapter order")
end

def referenced_chapter_paths(chapter)
  [
    chapter.fetch("path"),
    chapter.fetch("lab").fetch("path"),
    chapter.fetch("review_card").fetch("path"),
    chapter.fetch("suggested_contrast").fetch("path"),
    chapter.fetch("primary_case").fetch("path"),
    *chapter.fetch("complementary_cases").map { |case_ref| case_ref.fetch("path") },
    *chapter.fetch("notes")
  ]
end

def study_context_targets(chapter, area_by_id)
  [
    chapter.fetch("lab").fetch("path"),
    chapter.fetch("review_card").fetch("path"),
    chapter.fetch("suggested_contrast").fetch("path"),
    chapter.fetch("primary_case").fetch("path"),
    *chapter.fetch("complementary_cases").map { |case_ref| case_ref.fetch("path") },
    area_by_id.fetch(chapter.fetch("primary_area")).fetch("content_dirs").fetch("readme"),
    *chapter.fetch("secondary_areas").map { |area_id| area_by_id.fetch(area_id).fetch("content_dirs").fetch("readme") }
  ]
end

def validate_chapter_contract(chapter, phase_ids, area_ids, area_by_id)
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

  referenced_chapter_paths(chapter).each do |path|
    assert(exists?(path), "chapter #{number} references missing path: #{path}")
  end

  return unless exists?(chapter_path)

  body = ROOT.join(chapter_path).read
  assert(body.include?("# Chapter %02d - #{title}" % number), "chapter #{number} H1 does not match manifest title")
  assert(body.include?("## Study Context"), "chapter #{number} missing Study Context")

  study_context_targets(chapter, area_by_id).each do |target_path|
    assert(body.include?(relative_link(chapter_path, target_path)), "chapter #{number} Study Context missing link to #{target_path}")
  end

  if exists?(lab_path)
    assert(ROOT.join(lab_path).read.include?("# Lab - Chapter %02d" % number), "lab H1 mismatch for chapter #{number}")
  end

  if exists?(review_path)
    assert(ROOT.join(review_path).read.include?("# Review Card %02d - #{title}" % number), "review card H1 mismatch for chapter #{number}")
  end
end

def validate_chapters(chapters, phase_ids, area_ids, area_by_id)
  chapters.each do |chapter|
    validate_chapter_contract(chapter, phase_ids, area_ids, area_by_id)
  end
end

def validate_markdown_links
  Dir.glob(ROOT.join("**/*.md")).each do |file|
    path = Pathname(file)
    markdown_links(path.read).each do |target|
      next unless local_link?(target)

      clean_target = clean_local_target(target)
      next if clean_target.empty?

      target_path = path.dirname.join(clean_target).cleanpath
      assert(target_path.exist?, "broken markdown link in #{path.relative_path_from(ROOT)}: #{target}")
    end
  end
end

chapters = CURRICULUM.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }
areas = CURRICULUM.fetch("areas")
area_ids = areas.map { |area| area.fetch("id") }.to_set
area_by_id = areas.to_h { |area| [ area.fetch("id"), area ] }
phase_ids = CURRICULUM.fetch("phases").map { |phase| phase.fetch("id") }.to_set
phase_chapter_ids = CURRICULUM.fetch("phases").flat_map { |phase| phase.fetch("chapters") }

unless system(RbConfig.ruby, ROOT.join("scripts/render_curriculum_indexes.rb").to_s, "--check")
  error("generated curriculum indexes are stale; run ruby scripts/render_curriculum_indexes.rb")
end

validate_manifest_shape(chapters, phase_chapter_ids)
validate_area_paths(areas)
validate_chapters(chapters, phase_ids, area_ids, area_by_id)
validate_markdown_links

if @errors.any?
  puts @errors.map { |message| "- #{message}" }
  exit 1
end

puts "curriculum OK: #{chapters.size} chapters, #{areas.size} areas"
