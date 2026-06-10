# frozen_string_literal: true

source "https://rubygems.org"

# Keep the toolchain pinned to the same Ruby the curriculum scripts are tested
# against. Reads the version from .ruby-version so there is a single source.
ruby file: ".ruby-version"

# The curriculum scripts only use the standard library. Rake is the one tool we
# add so the render/validate/simulate workflow is reproducible via `bundle exec`.
gem "rake", "~> 13.2"
