# frozen_string_literal: true

require "rbconfig"

RUBY_BIN = RbConfig.ruby

desc "Render the generated curriculum indexes from curriculum.yml"
task :render do
  sh RUBY_BIN, "scripts/render_curriculum_indexes.rb"
end

desc "Validate the manifest, catalog contracts, generated blocks and links"
task :validate do
  sh RUBY_BIN, "scripts/validate_curriculum.rb"
end

desc "Run a numeric simulation lab, e.g. rake 'simulate[cache]'"
task :simulate, [:model] do |_task, args|
  model = args[:model] || ENV["MODEL"]
  abort "usage: rake 'simulate[<model>]' (try: rake simulate:list)" unless model
  sh RUBY_BIN, "simulation-labs/sim/run.rb", model, *ENV.fetch("ARGS", "").split
end

namespace :simulate do
  desc "List the available numeric simulation models"
  task :list do
    sh RUBY_BIN, "simulation-labs/sim/run.rb", "--list"
  end
end

desc "Show which spaced-repetition reviews are due (rake 'progress[2026-06-10]')"
task :progress, [:today] do |_task, args|
  args_for_script = [args[:today]].compact
  sh RUBY_BIN, "scripts/progress.rb", *args_for_script
end

namespace :drills do
  desc "Run the Ruby DSA drill suite"
  task :ruby do
    sh RUBY_BIN, "-Iinterview/dsa-drills/ruby/lib", "interview/dsa-drills/ruby/test/dsa_drills_test.rb"
  end

  desc "Run the TypeScript DSA drill suite"
  task :typescript do
    Dir.chdir("interview/dsa-drills/typescript") do
      sh "npm", "test"
    end
  end
end

desc "Run the executable DSA drill pack in Ruby and TypeScript"
task drills: ["drills:ruby", "drills:typescript"]

desc "CI gate: validate manifest + contracts + generated blocks + links"
task check: :validate

task default: :check
