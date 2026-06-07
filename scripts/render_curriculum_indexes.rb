#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "yaml"

ROOT = Pathname(__dir__).join("..").expand_path
CURRICULUM = YAML.safe_load(ROOT.join("curriculum.yml").read, aliases: true)
CHECK = ARGV.include?("--check")
@stale_blocks = []

def chapters
  CURRICULUM.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }
end

def areas
  CURRICULUM.fetch("areas")
end

def side_tracks
  CURRICULUM.fetch("side_tracks", [])
end

def area_by_id
  @area_by_id ||= areas.to_h { |area| [ area.fetch("id"), area ] }
end

def chapter_label(chapter)
  "Chapter %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ]
end

def relative_link(from_file, target_path)
  from_dir = ROOT.join(from_file).dirname
  target = ROOT.join(target_path)
  target.relative_path_from(from_dir).to_s
end

def link(from_file, label, target_path)
  "[#{label}](#{relative_link(from_file, target_path)})"
end

def replace_block(file, key, content)
  path = ROOT.join(file)
  markdown = path.read
  start_marker = "<!-- curriculum:start:#{key} -->"
  end_marker = "<!-- curriculum:end:#{key} -->"
  replacement = "#{start_marker}\n#{content.rstrip}\n#{end_marker}"

  raise "Missing curriculum marker #{key} in #{file}" unless markdown.include?(start_marker) && markdown.include?(end_marker)

  updated = markdown.sub(/#{Regexp.escape(start_marker)}.*?#{Regexp.escape(end_marker)}/m, replacement)

  if CHECK
    @stale_blocks << "#{file}:#{key}" if updated != markdown
  else
    path.write(updated) if updated != markdown
  end
end

def render_readme_start
  first = chapters.first

  [
    "Comece em #{link("README.md", chapter_label(first), first.fetch("path"))}.",
    "",
    "A trilha canonica vem de `curriculum.yml`. Quando ordem, lab, review, caso ou area mudarem, atualize o manifest e rode:",
    "",
    "```bash",
    "ruby scripts/render_curriculum_indexes.rb",
    "ruby scripts/validate_curriculum.rb",
    "```",
    "",
    "O validador tambem falha se algum bloco gerado ficar fora de sincronia com o manifest.",
    "",
    "Se quiser o mapa pedagogico da mesma trilha:",
    "- #{link("README.md", "Ordem de Estudo", "STUDY_ORDER.md")}",
    "- #{link("README.md", "Curriculum manifest", "curriculum.yml")}"
  ].join("\n")
end

def render_area_list
  areas.map do |area|
    "- #{link("README.md", "#{area.fetch("id").split("-").first} - #{area.fetch("title")}", area.fetch("content_dirs").fetch("readme"))} (`#{area.fetch("kind")}`)"
  end.join("\n")
end

def render_chapter_sequence(file)
  chapters.map do |chapter|
    area = area_by_id.fetch(chapter.fetch("primary_area"))
    case_link = link(file, chapter.fetch("primary_case").fetch("title"), chapter.fetch("primary_case").fetch("path"))
    area_link = link(file, area.fetch("title"), area.fetch("content_dirs").fetch("readme"))
    chapter_link = link(file, chapter_label(chapter), chapter.fetch("path"))

    "- #{chapter_link} - Caso: #{case_link} - Area: #{area_link}"
  end.join("\n")
end

def render_study_order
  phase_blocks = CURRICULUM.fetch("phases").map do |phase|
    phase_chapters = phase.fetch("chapters").map { |chapter_id| chapters.find { |chapter| chapter.fetch("id") == chapter_id } }
    [
      "### #{phase.fetch("title")}",
      "",
      phase_chapters.map { |chapter| study_order_entry(chapter) }.join("\n\n")
    ].join("\n")
  end

  phase_blocks.join("\n\n")
end

def study_order_entry(chapter)
  area = area_by_id.fetch(chapter.fetch("primary_area"))
  [
    "#{chapter.fetch("number")}. #{link("STUDY_ORDER.md", chapter_label(chapter), chapter.fetch("path"))}",
    "   Caso real: #{link("STUDY_ORDER.md", chapter.fetch("primary_case").fetch("title"), chapter.fetch("primary_case").fetch("path"))}",
    "   Area: #{link("STUDY_ORDER.md", "#{area.fetch("id").split("-").first} - #{area.fetch("title")}", area.fetch("content_dirs").fetch("readme"))}"
  ].join("\n")
end

def render_labs
  chapters.map do |chapter|
    "- #{link("labs/README.md", chapter_label(chapter), chapter.fetch("lab").fetch("path"))}"
  end.join("\n")
end

def render_reviews
  chapters.map do |chapter|
    "- #{link("reviews/README.md", "Card %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ], chapter.fetch("review_card").fetch("path"))}"
  end.join("\n")
end

def render_case_order
  chapters.map do |chapter|
    primary = chapter.fetch("primary_case")
    complements = chapter.fetch("complementary_cases", [])
    line = "- #{chapter_label(chapter)}: #{link("real-world-cases/ROADMAP.md", primary.fetch("title"), primary.fetch("path"))}"
    if complements.any?
      complement_links = complements.map { |case_ref| link("real-world-cases/ROADMAP.md", case_ref.fetch("title"), case_ref.fetch("path")) }
      line += " + #{complement_links.join(", ")}"
    end
    line
  end.join("\n")
end

def side_track_chapter_label(chapter)
  "Chapter %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ]
end

def side_track_review_label(chapter)
  "Card %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ]
end

def render_side_track_list(file)
  side_tracks.map do |track|
    area = area_by_id.fetch(track.fetch("area_id"))
    track_link = link(file, track.fetch("title"), track.fetch("path"))
    area_link = link(file, area.fetch("title"), area.fetch("content_dirs").fetch("readme"))
    source_link = link(file, "Source Map", track.fetch("source_map"))
    review_link = link(file, "Reviews", track.fetch("reviews_readme"))

    "- #{track_link} - Area: #{area_link} - #{source_link} - #{review_link}"
  end.join("\n")
end

def render_side_track_chapters(track)
  track.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }.map do |chapter|
    "#{chapter.fetch("number")}. #{link(track.fetch("path"), side_track_chapter_label(chapter), chapter.fetch("path"))}"
  end.join("\n")
end

def render_side_track_reviews(track)
  track.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }.map do |chapter|
    "- #{link(track.fetch("reviews_readme"), side_track_review_label(chapter), chapter.fetch("review_card"))}"
  end.join("\n")
end

replace_block("README.md", "readme-start", render_readme_start)
replace_block("README.md", "side-track-list", render_side_track_list("README.md"))
replace_block("README.md", "area-list", render_area_list)
replace_block("chapters/README.md", "chapter-sequence", render_chapter_sequence("chapters/README.md"))
replace_block("STUDY_ORDER.md", "study-order", render_study_order)
replace_block("labs/README.md", "labs-by-chapter", render_labs)
replace_block("reviews/README.md", "review-cards", render_reviews)
replace_block("real-world-cases/ROADMAP.md", "canonical-case-order", render_case_order)
replace_block("areas/08-sistemas-ia/README.md", "side-track-list", render_side_track_list("areas/08-sistemas-ia/README.md"))

side_tracks.each do |track|
  replace_block(track.fetch("path"), "#{track.fetch("id")}-chapters", render_side_track_chapters(track))
  replace_block(track.fetch("reviews_readme"), "#{track.fetch("id")}-review-cards", render_side_track_reviews(track))
end

if CHECK
  if @stale_blocks.any?
    puts "stale curriculum indexes:"
    puts @stale_blocks.map { |block| "- #{block}" }
    exit 1
  end

  puts "curriculum indexes OK"
else
  puts "curriculum indexes rendered"
end
