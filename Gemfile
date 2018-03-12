# frozen_string_literal: true

source "http://rubygems.org"

gemspec

# Uncomment and change rails version for testing purposes
gem "rails", "~> 5.2.0.rc1"

group :development do
  gem "rubocop", require: false
end

group :test do
  gem "coveralls", require: false
  gem "diffy"
  gem "equivalent-xml"
  gem "minitest"
  gem "sqlite3"
end
