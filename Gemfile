source "https://rubygems.org"

# Specify your gem's dependencies in object_view.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "propshaft"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development, :test do
  gem "faker"
  gem "capybara", ">= 2.15"
  gem "database_cleaner"
  gem "rspec-rails", "~> 8.0.0"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
end
