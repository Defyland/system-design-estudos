#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "rbconfig"
require "set"
require "json"
require "yaml"

# Read every file as UTF-8 regardless of the host locale. Without this the
# script crashes with "invalid byte sequence in US-ASCII" whenever the default
# external encoding is not UTF-8 (e.g. the system Ruby on macOS), because the
# study content is full of accented Portuguese text.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ROOT = Pathname(__dir__).join("..").expand_path
WORKSPACE_ROOT = ROOT.parent
PORTFOLIO_MAP_PATH = "areas/12-engineering-practice/cards/backend-portfolio-evidence-map.md"
READINESS_BASE_PATH = WORKSPACE_ROOT.join(".agents/eval-reports/full-program-readiness-2026-06-29.json")
READINESS_DASHBOARD_PATH = WORKSPACE_ROOT.join(".agents/eval-reports/release-readiness-dashboard.md")
PUBLICATION_BASELINE_PATH = WORKSPACE_ROOT.join(".agents/eval-reports/publication-baseline-2026-06-29.md")
CURRICULUM = YAML.safe_load(ROOT.join("curriculum.yml").read, aliases: true)
CATALOG_CONTRACTS = {
  "topic_catalog" => {
    "dir_key" => "topics",
    "readme_prefix" => "./topics/",
    "required_sections" => [
      "When to Use",
      "Interview Trap"
    ]
  },
  "component_catalog" => {
    "dir_key" => "cards",
    "readme_prefix" => "./cards/",
    "required_sections" => [
      "When to Use",
      "What Breaks First",
      "Interview Trap"
    ]
  },
  "backend_principle_catalog" => {
    "dir_key" => "cards",
    "readme_prefix" => "./cards/",
    "required_sections" => [
      "When to Use",
      "What Breaks First",
      "Interview Trap",
      "Practice Drill",
      "Source Anchor"
    ]
  },
  "engineering_case_study_catalog" => {
    "dir_key" => "cards",
    "readme_prefix" => "./cards/",
    "required_sections" => [
      "Case Pattern",
      "When to Use",
      "What Breaks First",
      "Interview Trap",
      "Practice Drill",
      "Source Anchor"
    ]
  },
  "operational_playbook_catalog" => {
    "dir_key" => "playbooks",
    "readme_prefix" => "./playbooks/",
    "required_sections" => [
      "Trigger",
      "Signals",
      "Immediate Actions",
      "Stabilize",
      "Deep Checks",
      "Exit Criteria",
      "Practice Drill",
      "Source Anchor"
    ]
  },
  "engineering_practice_catalog" => {
    "dir_key" => "cards",
    "readme_prefix" => "./cards/",
    "required_sections" => [
      "When to Use",
      "What Breaks First",
      "Design Moves",
      "Interview Trap",
      "Practice Drill",
      "Source Anchor"
    ]
  },
  "backend_lab_catalog" => {
    "dir_key" => "labs",
    "readme_prefix" => "./labs/",
    "required_sections" => [
      "Objective",
      "Setup",
      "Tasks",
      "Exit Criteria",
      "Deliverable",
      "Linked Concepts"
    ]
  },
  "engineering_case_lab_catalog" => {
    "dir_key" => "labs",
    "readme_prefix" => "./labs/",
    "required_sections" => [
      "Objective",
      "Setup",
      "Tasks",
      "Exit Criteria",
      "Deliverable",
      "Linked Concepts"
    ]
  }
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
  contract = CATALOG_CONTRACTS[area.fetch("kind")]
  return unless contract

  dir_key = contract.fetch("dir_key")
  required_sections = contract.fetch("required_sections")
  content_dir = area.fetch("content_dirs").fetch(dir_key, nil)
  unless content_dir
    error("area #{area.fetch("id")} missing #{dir_key} content dir")
    return
  end

  content_path = ROOT.join(content_dir)
  assert(content_path.directory?, "area #{area.fetch("id")} #{dir_key} path is not a directory: #{content_dir}")
  return unless content_path.directory?

  documents = markdown_cards(content_dir)
  assert(documents.any?, "area #{area.fetch("id")} has no markdown documents: #{content_dir}")
  validate_area_readme_cards(area, documents, contract.fetch("readme_prefix"))

  documents.each do |document|
    body = document.read
    relative_path = document.relative_path_from(ROOT)
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

def validate_area_readme_cards(area, documents, readme_prefix)
  readme_path = ROOT.join(area.fetch("content_dirs").fetch("readme"))
  readme_body = readme_path.read
  listed_card_paths = markdown_links(readme_body)
    .map { |target| clean_local_target(target) }
    .select { |target| target.start_with?(readme_prefix) && target.end_with?(".md") }
    .map { |target| readme_path.dirname.join(target).cleanpath.relative_path_from(ROOT).to_s }
    .sort
  actual_card_paths = documents.map { |document| document.relative_path_from(ROOT).to_s }.sort

  missing = actual_card_paths - listed_card_paths
  extra = listed_card_paths - actual_card_paths

  assert(missing.empty?, "area #{area.fetch("id")} README missing cards: #{missing.join(", ")}")
  assert(extra.empty?, "area #{area.fetch("id")} README lists unknown cards: #{extra.join(", ")}")
end

def validate_practice_area(area)
  return unless area.fetch("kind") == "practice_area"

  content_dirs = area.fetch("content_dirs")
  readme_path = ROOT.join(content_dirs.fetch("readme"))
  listed = markdown_links(readme_path.read)
    .map { |target| clean_local_target(target) }
    .select { |target| local_link?(target) }
    .map { |target| readme_path.dirname.join(target).cleanpath.relative_path_from(ROOT).to_s }
    .to_set

  %w[examples snippets].each do |sub|
    dir = content_dirs.fetch(sub, nil)
    next unless dir && ROOT.join(dir).directory?

    markdown_cards(dir).each do |document|
      next if document.basename.to_s == "README.md"

      relative_path = document.relative_path_from(ROOT).to_s
      assert(listed.include?(relative_path), "practice area #{area.fetch("id")} README missing link to #{relative_path}")
    end
  end

  notes = content_dirs.fetch("notes", nil)
  return unless notes && exists?(notes)

  h1_count = ROOT.join(notes).read.scan(/^# [^\n]+$/).size
  assert(h1_count == 1, "practice area #{area.fetch("id")} notes must have exactly one H1: #{notes}")
end

def validate_area_paths(areas)
  areas.each do |area|
    area.fetch("content_dirs").each_value do |path|
      assert(exists?(path), "area path missing: #{path}")
    end

    validate_card_contract(area)
    validate_practice_area(area)
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
    *chapter.fetch("notes"),
    *simulation_paths(chapter),
    *chapter.fetch("playbooks", []),
    *chapter.fetch("bridge_labs", []),
    *chapter.fetch("foundations", [])
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
    *chapter.fetch("secondary_areas").map { |area_id| area_by_id.fetch(area_id).fetch("content_dirs").fetch("readme") },
    *simulation_paths(chapter),
    *chapter.fetch("playbooks", []),
    *chapter.fetch("bridge_labs", []),
    *chapter.fetch("foundations", [])
  ]
end

def simulation_paths(chapter)
  chapter.fetch("simulations", []).map { |simulation| "simulation-labs/#{simulation}.md" }
end

def validate_chapter_contract(chapter, phase_ids, area_ids, area_by_id, simulation_ids)
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
  chapter.fetch("simulations", []).each do |simulation_id|
    assert(simulation_ids.include?(simulation_id), "unknown simulation #{simulation_id} for chapter #{number}")
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

def validate_simulation_catalog(simulation_ids)
  assert(simulation_ids.uniq.size == simulation_ids.size, "simulation_labs ids must be unique")

  simulation_ids.each do |simulation_id|
    assert(exists?("simulation-labs/#{simulation_id}.md"), "simulation path missing: simulation-labs/#{simulation_id}.md")
  end
end

def validate_chapters(chapters, phase_ids, area_ids, area_by_id, simulation_ids)
  chapters.each do |chapter|
    validate_chapter_contract(chapter, phase_ids, area_ids, area_by_id, simulation_ids)
  end
end

def side_track_chapter_label(chapter)
  "Chapter %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ]
end

def side_track_review_label(chapter)
  "Card %02d - %s" % [ chapter.fetch("number"), chapter.fetch("title") ]
end

def validate_side_track_readme(track, chapters)
  readme_path = ROOT.join(track.fetch("path"))
  body = readme_path.read
  listed_paths = markdown_links(body)
    .map { |target| clean_local_target(target) }
    .select { |target| (target.start_with?("./chapters/") || target.start_with?("chapters/")) && target.end_with?(".md") }
    .map { |target| readme_path.dirname.join(target).cleanpath.relative_path_from(ROOT).to_s }
    .sort
  actual_paths = chapters.map { |chapter| chapter.fetch("path") }.sort

  missing = actual_paths - listed_paths
  extra = listed_paths - actual_paths

  assert(missing.empty?, "side track #{track.fetch("id")} README missing chapters: #{missing.join(", ")}")
  assert(extra.empty?, "side track #{track.fetch("id")} README lists unknown chapters: #{extra.join(", ")}")
end

def validate_side_track_reviews_readme(track, chapters)
  readme_path = ROOT.join(track.fetch("reviews_readme"))
  body = readme_path.read
  listed_paths = markdown_links(body)
    .map { |target| clean_local_target(target) }
    .select { |target| (target.start_with?("./cards/") || target.start_with?("cards/")) && target.end_with?(".md") }
    .map { |target| readme_path.dirname.join(target).cleanpath.relative_path_from(ROOT).to_s }
    .sort
  actual_paths = chapters.map { |chapter| chapter.fetch("review_card") }.sort

  missing = actual_paths - listed_paths
  extra = listed_paths - actual_paths

  assert(missing.empty?, "side track #{track.fetch("id")} reviews README missing cards: #{missing.join(", ")}")
  assert(extra.empty?, "side track #{track.fetch("id")} reviews README lists unknown cards: #{extra.join(", ")}")
end

def validate_side_track_review_card(track, chapter)
  review_path = chapter.fetch("review_card")
  body = ROOT.join(review_path).read

  assert(body.include?("# Review #{side_track_review_label(chapter)}"), "side track #{track.fetch("id")} review H1 mismatch for chapter #{chapter.fetch("number")}")

  [
    "Anchor",
    "Cue Signal",
    "Case/Bridge Anchor",
    "QDSAA Recall",
    "Trade-off to Remember",
    "Trap",
    "1-Minute Answer"
  ].each do |section|
    assert(body.match?(/^## #{Regexp.escape(section)}\s*$/), "side track #{track.fetch("id")} review card missing section #{section}: #{review_path}")
  end
end

def validate_side_track_chapter(track, chapter)
  chapter_path = chapter.fetch("path")
  body = ROOT.join(chapter_path).read

  assert(body.include?("# #{side_track_chapter_label(chapter)}"), "side track #{track.fetch("id")} chapter H1 mismatch for chapter #{chapter.fetch("number")}")
  assert(body.include?("## Study Context"), "side track #{track.fetch("id")} chapter #{chapter.fetch("number")} missing Study Context")
  assert(body.include?(relative_link(chapter_path, chapter.fetch("review_card"))), "side track #{track.fetch("id")} chapter #{chapter.fetch("number")} missing review link")

  chapter.fetch("bridge_topics", []).each do |target_path|
    assert(body.include?(relative_link(chapter_path, target_path)), "side track #{track.fetch("id")} chapter #{chapter.fetch("number")} missing bridge topic #{target_path}")
  end

  chapter.fetch("bridge_cases", []).each do |target_path|
    assert(body.include?(relative_link(chapter_path, target_path)), "side track #{track.fetch("id")} chapter #{chapter.fetch("number")} missing bridge case #{target_path}")
  end

  chapter.fetch("upstream", []).each do |url|
    assert(body.include?(url), "side track #{track.fetch("id")} chapter #{chapter.fetch("number")} missing upstream link #{url}")
  end

  validate_side_track_review_card(track, chapter)
end

def validate_side_track_contract(track, area_ids)
  track_id = track.fetch("id")
  chapters = track.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }

  assert(area_ids.include?(track.fetch("area_id")), "side track #{track_id} references unknown area #{track.fetch("area_id")}")
  assert(chapters.map { |chapter| chapter.fetch("number") } == (1..chapters.size).to_a, "side track #{track_id} chapter numbers must be sequential")
  assert(chapters.map { |chapter| chapter.fetch("path") }.uniq.size == chapters.size, "side track #{track_id} chapter paths must be unique")
  assert(chapters.map { |chapter| chapter.fetch("review_card") }.uniq.size == chapters.size, "side track #{track_id} review card paths must be unique")

  [
    track.fetch("path"),
    track.fetch("source_map"),
    track.fetch("reviews_readme"),
    *chapters.flat_map { |chapter| [ chapter.fetch("path"), chapter.fetch("review_card"), *chapter.fetch("bridge_topics", []), *chapter.fetch("bridge_cases", []) ] }
  ].each do |path|
    assert(exists?(path), "side track #{track_id} references missing path: #{path}")
  end

  return unless exists?(track.fetch("path")) && exists?(track.fetch("reviews_readme"))

  body = ROOT.join(track.fetch("path")).read
  assert(body.include?("# #{track.fetch("title")}"), "side track #{track_id} H1 does not match manifest title")

  validate_side_track_readme(track, chapters)
  validate_side_track_reviews_readme(track, chapters)
  chapters.each { |chapter| validate_side_track_chapter(track, chapter) }
end

def validate_side_tracks(side_tracks, area_ids)
  assert(side_tracks.map { |track| track.fetch("id") }.uniq.size == side_tracks.size, "side track ids must be unique")
  side_tracks.each do |track|
    validate_side_track_contract(track, area_ids)
  end
end

def link_fragment(target)
  return nil unless target.include?("#")

  fragment = target.split("#", 2).last
  fragment.empty? ? nil : fragment
end

# Mirrors GitHub's heading -> anchor slug: downcase, drop formatting and
# punctuation, turn spaces into hyphens. Unicode letters (accents) are kept.
def github_anchor(text)
  text.strip.downcase.delete("`").gsub(/[^\p{Word}\- ]/u, "").tr(" ", "-")
end

def heading_anchors(body)
  body.scan(/^\#{1,6}[ \t]+(.+?)[ \t\#]*$/).flatten.map { |heading| github_anchor(heading) }.to_set
end

def validate_markdown_links
  Dir.glob(ROOT.join("**/*.md")).each do |file|
    path = Pathname(file)
    body = path.read
    own_anchors = nil

    markdown_links(body).each do |target|
      fragment = link_fragment(target)

      if target.start_with?("#")
        next unless fragment

        own_anchors ||= heading_anchors(body)
        assert(own_anchors.include?(fragment), "broken in-page anchor in #{path.relative_path_from(ROOT)}: #{target}")
        next
      end

      next unless local_link?(target)

      clean_target = clean_local_target(target)
      next if clean_target.empty?

      target_path = path.dirname.join(clean_target).cleanpath
      unless target_path.exist?
        error("broken markdown link in #{path.relative_path_from(ROOT)}: #{target}")
        next
      end

      next unless fragment && target_path.extname == ".md"

      assert(
        heading_anchors(target_path.read).include?(fragment),
        "broken anchor in #{path.relative_path_from(ROOT)}: #{target}"
      )
    end
  end
end

def split_markdown_row(line)
  line.split("|")[1..-2].to_a.map(&:strip)
end

def first_markdown_link_target(text)
  text[/\[[^\]]+\]\(([^)]+)\)/, 1]
end

def workspace_repo_name_for_absolute_path(path)
  clean = path.cleanpath
  return ROOT.basename.to_s if clean == ROOT || clean.to_s.start_with?("#{ROOT}/")
  return nil unless clean.to_s.start_with?("#{WORKSPACE_ROOT}/")

  clean.relative_path_from(WORKSPACE_ROOT).each_filename.first
rescue ArgumentError
  nil
end

def portfolio_repo_name_for_link(source_path, target)
  clean_target = clean_local_target(target)
  return nil if clean_target.empty?

  resolved = ROOT.join(source_path).dirname.join(clean_target).cleanpath
  workspace_repo_name_for_absolute_path(resolved)
end

def portfolio_repo_name_for_command(command)
  clean_command = command.strip.delete_prefix("`").delete_suffix("`")
  if clean_command.match?(/\Acd\s+/)
    target = clean_command[/\Acd\s+([^\s&]+)\s*&&/, 1]
    return nil unless target

    resolved = ROOT.join(target).cleanpath
    return nil unless resolved.directory?

    return workspace_repo_name_for_absolute_path(resolved)
  end

  ROOT.basename.to_s
end

def load_base_readiness_by_repo
  return {} unless READINESS_BASE_PATH.exist?

  JSON.parse(READINESS_BASE_PATH.read).fetch("reports").to_h do |report|
    [ report.fetch("name"), report.fetch("summary").fetch("ready") ]
  end
end

def load_dashboard_readiness_overrides
  return {} unless READINESS_DASHBOARD_PATH.exist?

  section = nil
  overrides = {}

  READINESS_DASHBOARD_PATH.each_line do |line|
    case line
    when /^## Ready Now/
      section = :ready
    when /^## Blocked By Real Gaps/
      section = :blocked
    when /^## /
      section = nil
    else
      next unless section && line.start_with?("| `")

      repo = split_markdown_row(line).first.to_s[/`([^`]+)`/, 1]
      next unless repo

      overrides[repo] = (section == :ready)
    end
  end

  overrides
end

def load_ready_public_repos
  return nil unless PUBLICATION_BASELINE_PATH.exist?

  section = nil
  repos = Set.new

  PUBLICATION_BASELINE_PATH.each_line do |line|
    case line
    when /^## Ready Now/
      section = :ready
    when /^## /
      section = nil
    else
      next unless section == :ready && line.start_with?("| `")

      repo = split_markdown_row(line).first.to_s[/`([^`]+)`/, 1]
      repos << repo if repo
    end
  end

  repos
end

def portfolio_evidence_rows(body)
  body.each_line.filter_map.with_index(1) do |line, lineno|
    next unless line.start_with?("|")

    columns = split_markdown_row(line)
    next unless columns.size == 7
    next if columns.first == "Concept"
    next unless columns[1].include?("](") && columns[2].include?("](")

    {
      line: lineno,
      concept: columns[0],
      project: columns[1],
      evidence: columns[2],
      command: columns[3],
      trust: columns[4],
      operational_lesson: columns[6]
    }
  end
end

def validate_backend_portfolio_evidence_map
  return unless exists?(PORTFOLIO_MAP_PATH)

  readiness_by_repo = load_base_readiness_by_repo.merge(load_dashboard_readiness_overrides)
  ready_public_repos = load_ready_public_repos
  body = ROOT.join(PORTFOLIO_MAP_PATH).read

  portfolio_evidence_rows(body).each do |row|
    project_target = first_markdown_link_target(row.fetch(:project))
    evidence_target = first_markdown_link_target(row.fetch(:evidence))
    project_repo = portfolio_repo_name_for_link(PORTFOLIO_MAP_PATH, project_target.to_s)
    evidence_repo = portfolio_repo_name_for_link(PORTFOLIO_MAP_PATH, evidence_target.to_s)
    command_repo = portfolio_repo_name_for_command(row.fetch(:command))

    assert(project_repo, "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} has unresolvable project link")
    assert(evidence_repo, "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} has unresolvable evidence link")
    next unless project_repo && evidence_repo

    assert(
      project_repo == evidence_repo,
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} mixes project repo #{project_repo} with evidence repo #{evidence_repo}"
    )
    assert(
      command_repo == project_repo,
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} points command repo #{command_repo || 'unknown'} at a different repo than the project link #{project_repo}"
    )

    authority_ready = readiness_by_repo.fetch(project_repo, nil)
    assert(
      !authority_ready.nil?,
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} references repo missing from readiness authority: #{project_repo}"
    )
    next if authority_ready.nil?

    ready_marker = row.fetch(:trust)[/`ready:\s*(yes|no)`/, 1]
    expected_marker = authority_ready ? "yes" : "no"
    assert(
      ready_marker == expected_marker,
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} says ready #{ready_marker || 'missing'} but authority says #{expected_marker} for #{project_repo}"
    )

    expected_label = authority_ready ? "Trusted first" : "Em construcao"
    assert(
      row.fetch(:trust).include?(expected_label),
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} should use trust label #{expected_label.inspect}"
    )

    if ready_public_repos
      public_marker = row.fetch(:trust)[/`public:\s*(yes|no)`/, 1]
      expected_public = ready_public_repos.include?(project_repo) ? "yes" : "no"
      assert(
        public_marker == expected_public,
        "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} says public #{public_marker || 'missing'} but authority says #{expected_public} for #{project_repo}"
      )
    end

    assert(
      !row.fetch(:operational_lesson).strip.empty?,
      "portfolio evidence row #{row.fetch(:concept)} line #{row.fetch(:line)} must include an operational lesson"
    )
  end
end

chapters = CURRICULUM.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }
areas = CURRICULUM.fetch("areas")
area_ids = areas.map { |area| area.fetch("id") }.to_set
area_by_id = areas.to_h { |area| [ area.fetch("id"), area ] }
phase_ids = CURRICULUM.fetch("phases").map { |phase| phase.fetch("id") }.to_set
phase_chapter_ids = CURRICULUM.fetch("phases").flat_map { |phase| phase.fetch("chapters") }
simulation_ids = CURRICULUM.fetch("simulation_labs")
side_tracks = CURRICULUM.fetch("side_tracks", [])

unless system(RbConfig.ruby, ROOT.join("scripts/render_curriculum_indexes.rb").to_s, "--check")
  error("generated curriculum indexes are stale; run ruby scripts/render_curriculum_indexes.rb")
end

validate_manifest_shape(chapters, phase_chapter_ids)
validate_area_paths(areas)
validate_simulation_catalog(simulation_ids)
validate_chapters(chapters, phase_ids, area_ids, area_by_id, simulation_ids.to_set)
validate_side_tracks(side_tracks, area_ids)
validate_markdown_links
validate_backend_portfolio_evidence_map

if @errors.any?
  puts @errors.map { |message| "- #{message}" }
  exit 1
end

puts "curriculum OK: #{chapters.size} chapters, #{areas.size} areas, #{side_tracks.size} side tracks"
