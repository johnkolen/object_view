source "https://rubygems.org"

# Specify your gem's dependencies in object_view.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "propshaft"

gem "importmap-rails"
gem "turbo-rails", "~> 2.0.13"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "dartsass-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development, :test do
  gem "faker", "~> 3.5"
  gem "capybara", ">= 2.15"
  gem "database_cleaner-active_record", "~> 2.2.1"
  gem "rspec-rails", "~> 8.0.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "rails-controller-testing"
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end
