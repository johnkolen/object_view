require_relative "../generator_helpers"

module ObjectView
  class RspecGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)
    include ObjectView::GeneratorHelpers

    def create_factory
      template "factory.rb.tt", "spec/factories/#{plural_name}.rb"
    end

    def factory_definition
      <<~RUBY
            factory :#{factory_name}#{explicit_class_option} do
          #{factory_attributes(NORMAL).gsub(/^/, "    ")}
            end

            factory :#{factory_name}_sample#{explicit_class_option} do
          #{factory_attributes(SAMPLE).gsub(/^/, "    ")}
            end

        RUBY
    end

    def factory_name
      class_name.gsub("::", "").underscore
    end

    def explicit_class_option
      return if class_name.underscore == factory_name

      ", class: '#{class_name}'"
    end

    NORMAL = {
      binary: "binary",
      boolean: true,
      date: Date.new(2025, 6, 29),
      datetime: DateTime.new(2025, 6, 29, 8, 9, 10),
      decimal: BigDecimal("1.23"),
      float: 1.234,
      integer: 1,
      string: "string",
      text: "text",
      time: Time.new(2025, 6, 29, 8, 9, 10),
      timestamp: DateTime.new(2025, 6, 29, 8, 9, 10),
    }

    class Code
      def initialize str
        @str = str
      end
      def inspect
        @str
      end
    end

    SAMPLE = {
      binary: Code.new("'binary:' + Faker::Alphanumeric.alphanumeric(number: 10)"),
      boolean: Code.new("rand(2) == 1"),
      date: Code.new("Date.new(Faker::Date.between(from: 2.years.ago, to: Date.today))"),
      datetime: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))"),
      decimal: Code.new("BigDecimal(\"%d.%02d\" % [rand(100), rand(100)])"),
      float: Code.new("rand(10000) / 100.0"),
      integer: Code.new("rand(1000)"),
      string: Code.new("Faker::Alphanumeric.alphanumeric(number: 10)"),
      text: Code.new("Faker::Alphanumeric.alphanumeric(number: 10)"),
      time: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))"),
      timestamp: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))"),
    }

    def request_files
      %w[requests].each do |x|
        fname = "#{x}.rb"
        template "#{fname}.tt",
                 "spec/requests/#{name.pluralize}_spec.rb"
      end
    end

    def add_to_rails_helper
      inject_into_file "spec/rails_helper.rb",
                       "require ObjectView::Engine.root.join(\"spec/object_view/rspec/helpers\")\n",
                       after: "require 'rspec/rails'"
      includes = <<~RUBY
        config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
        config.before(:each) { DatabaseCleaner.strategy = :transaction }
        config.before(:each, js: true) { DatabaseCleaner.strategy = :transaction }
        config.before(:each) { DatabaseCleaner.start }
        config.before(:each) { DatabaseCleaner.clean }
        config.include FactoryBot::Syntax::Methods
        config.include Devise::Test::ControllerHelpers, type: :controller
        config.include Devise::Test::ControllerHelpers, type: :view
        config.include Devise::Test::IntegrationHelpers, type: :request
        config.include Devise::Test::IntegrationHelpers, type: :system
        config.include ControllerSetup, type: :view
        config.include ControllerSetup, type: :request
        config.include ControllerSetup, type: :helper
        config.include ObjectView::Rspec::Requests, type: request
      RUBY
      inject_into_file "spec/rails_helper.rb",
                       "\n"+includes.gsub(/^/,"  "),
                       after: "# config.filter_gems_from_backtrace(\"gem name\")"
    end

    private

    def factory_attributes src
      attributes_map(class_name) do |attr, type|
        "#{attr} { #{src[type.type].inspect} }"
      end.join("\n")
    end
  end
end
