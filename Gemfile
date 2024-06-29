# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in jekyll-wikirefs.gemspec
gemspec

gem 'jekyll'

gem 'nokogiri', '~> 1.13.3'

gem 'rake', '~> 13.0.3'
gem 'rspec', '~> 3.10.0'
gem 'rubocop', '~> 1.14.0'

gem 'webrick', '~> 1.7'

# create multiple gemfiles in order to test plugin against multiple jekyll versions
Bundler::Plugin.add_hook("after-install-all") do |dependencies|
  system("bin/generate_gemfiles.sh")
end
