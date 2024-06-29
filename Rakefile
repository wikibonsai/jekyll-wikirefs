# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

require 'optparse'

desc "generate Gemfiles (for target major Jekyll versions)"
task :gen do
  sh "bin/generate_gemfiles"
end

# Default to not generating Gemfiles unless specified
$options = { generate_gemfiles: false }

OptionParser.new do |opts|
  opts.banner = "Usage: rake spec [options]"

  opts.on("-g", "--generate-gemfiles", "Generate Gemfiles before running specs") do |g|
    $options[:generate_gemfiles] = g
  end
end.parse!

desc "Run tests for all Jekyll versions"
task :spec do
  if $options[:generate_gemfiles]
    sh "bin/generate_gemfiles.sh"
  end

  versions = ["4.2.0", "4.3.0"]
  versions.each do |version|
    ENV['BUNDLE_GEMFILE'] = "Gemfile.jekyll-#{version}"
    sh "bundle exec rspec"
  end
end

desc "Clean generated Gemfiles (for target major Jekyll versions)"
task :clean do
  sh "bin/clean_gemfiles"
end
