#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "pathname"
require "yaml"

# Same UTF-8 guard as the other scripts so accented output never trips a host
# with a non-UTF-8 locale.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ROOT = Pathname(__dir__).join("..").expand_path
CURRICULUM = YAML.safe_load(ROOT.join("curriculum.yml").read, aliases: true)
PROGRESS_PATH = ROOT.join("progress.yml")

abort "progress.yml not found at #{PROGRESS_PATH}" unless PROGRESS_PATH.exist?

progress = YAML.safe_load(PROGRESS_PATH.read, permitted_classes: [Date]) || {}
offsets = Array(progress["review_offsets_days"]).map(&:to_i).reject(&:zero?).sort
offsets = [1, 3, 7, 14, 30] if offsets.empty?
started = progress["chapters"] || {}

today =
  begin
    ARGV[0] ? Date.parse(ARGV[0]) : Date.today
  rescue ArgumentError
    abort "Data invalida: #{ARGV[0]} (use YYYY-MM-DD)"
  end

chapters = CURRICULUM.fetch("chapters").sort_by { |chapter| chapter.fetch("number") }
label_for = chapters.to_h do |chapter|
  [ chapter.fetch("id"), format("Chapter %02d - %s", chapter.fetch("number"), chapter.fetch("title")) ]
end

def to_date(value)
  return value if value.is_a?(Date)
  return nil if value.nil? || value.to_s.strip.empty?

  Date.parse(value.to_s)
rescue ArgumentError
  nil
end

due_today = []
overdue = []
upcoming = []
not_started = []
completed = []

manifest_ids = chapters.map { |chapter| chapter.fetch("id") }
missing_from_progress = manifest_ids - started.keys
unknown_in_progress = started.keys - manifest_ids

chapters.each do |chapter|
  id = chapter.fetch("id")
  start = to_date(started[id])
  if start.nil?
    not_started << label_for[id]
    next
  end

  reviews = offsets.map { |offset| { offset: offset, date: start + offset } }
  passed = reviews.select { |review| review[:date] <= today }
  future = reviews.select { |review| review[:date] > today }
  current = passed.max_by { |review| review[:date] }
  nextup = future.min_by { |review| review[:date] }

  if current && current[:date] == today
    due_today << { label: label_for[id], offset: current[:offset] }
  elsif current && current[:offset] == offsets.last && future.empty?
    completed << label_for[id]
  elsif current
    overdue << { label: label_for[id], offset: current[:offset], date: current[:date] }
  end

  upcoming << { label: label_for[id], offset: nextup[:offset], date: nextup[:date] } if nextup
end

puts "Revisoes para #{today} (offsets D+#{offsets.join(', D+')})"
puts

unless due_today.empty?
  puts "Vencendo hoje:"
  due_today.each { |entry| puts "  - #{entry[:label]} (D+#{entry[:offset]})" }
  puts
end

unless overdue.empty?
  puts "Atrasadas (checkpoint atual ja passou):"
  overdue.sort_by { |entry| entry[:date] }.each do |entry|
    puts "  - #{entry[:label]} (D+#{entry[:offset]}, era #{entry[:date]})"
  end
  puts
end

horizon = today + 7
soon = upcoming.select { |entry| entry[:date] <= horizon }.sort_by { |entry| entry[:date] }
unless soon.empty?
  puts "Proximas (ate #{horizon}):"
  soon.each { |entry| puts "  - #{entry[:date]} #{entry[:label]} (D+#{entry[:offset]})" }
  puts
end

summary = []
summary << "#{completed.size} concluida(s)" unless completed.empty?
summary << "#{not_started.size} nao iniciada(s)" unless not_started.empty?
puts summary.join(" - ") unless summary.empty?

warn "Aviso: chapters do manifest sem entrada em progress.yml: #{missing_from_progress.join(', ')}" if missing_from_progress.any?
warn "Aviso: entradas em progress.yml fora do manifest: #{unknown_in_progress.join(', ')}" if unknown_in_progress.any?
