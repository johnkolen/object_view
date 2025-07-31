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

              factory :#{factory_name}_sample#{explicit_class_option} do
            #{factory_attributes(SAMPLE).gsub(/^/, "    ")}
              end
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

    class Code
      def initialize(str)
        @str = str
      end
      def inspect
        @str
      end
    end

    NORMAL = {
      binary: "binary",
      boolean: true,
      date: Code.new("Date.new(2025, 6, 29)"),
      datetime: Code.new("DateTime.new(2025, 6, 29, 8, 9, 10)"),
      decimal: Code.new("BigDecimal(\"1.23\")"),
      float: 1.234,
      integer: 1,
      string: "string",
      text: "text",
      time: Code.new("Time.new(2025, 6, 29, 8, 9, 10)"),
      timestamp: Code.new("DateTime.new(2025, 6, 29, 8, 9, 10)")
    }

    SAMPLE = {
      binary: Code.new("'binary:' + Faker::Alphanumeric.alphanumeric(number: 10)"),
      boolean: Code.new("rand(2) == 1"),
      date: Code.new("Faker::Date.between(from: 2.years.ago, to: Date.today)"),
      datetime: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))"),
      decimal: Code.new("BigDecimal(\"%d.%02d\" % [rand(100), rand(100)])"),
      float: Code.new("rand(10000) / 100.0"),
      integer: Code.new("rand(1000)"),
      string: Code.new("Faker::Alphanumeric.alphanumeric(number: 10)"),
      text: Code.new("Faker::Alphanumeric.alphanumeric(number: 10)"),
      time: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))"),
      timestamp: Code.new("DateTime.new(Faker::Time.between(from: 2.years.ago, to: Date.today))")
    }

    def request_files
      %w[requests].each do |x|
        fname = "#{x}.rb"
        template "#{fname}.tt",
                 "spec/requests/#{name.pluralize}_spec.rb"
      end
    end

    def create_views_files
      %w[edit index new show].each do |x|
        fname = "#{x}.html.erb_spec.rb"
        template "#{fname}.tt",
                 "spec/views/#{plural_name}/#{fname}"
      end
    end

    def create_model_files
      %w[model].each do |x|
        fname = "#{x}.rb"
        template "#{fname}.tt",
                 "spec/models/#{name}_spec.rb"
      end
    end

    def create_standard_rspec
      generate "rspec:scaffold",
               name,
               "--no-controller_specs",
               "--no-request_specs",
               "--no-view_specs"
      generate "rspec:feature",
               plural_name
      generate "rspec:system",
               plural_name
    end

    def add_to_rails_helper
      unless grep? "spec/rails_helper.rb", "ObjectView"
        inject_into_file "spec/rails_helper.rb",
                         "require ObjectView::Engine.root.join(\"spec/object_view/rspec/helpers\")\n",
                         after: "require 'rspec/rails'\n"
        includes = <<~RUBY
        config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
        config.before(:each) { DatabaseCleaner.strategy = :transaction }
        config.before(:each, js: true) { DatabaseCleaner.strategy = :transaction }
        config.before(:each) { DatabaseCleaner.start }
        config.before(:each) { DatabaseCleaner.clean }
        config.include FactoryBot::Syntax::Methods
        if defined? Devise
          config.include Devise::Test::IntegrationHelpers, type: :controller
          config.include Devise::Test::IntegrationHelpers, type: :request
        end
        config.include ObjectView::Rspec::Setup, type: :request
        config.include ObjectView::Rspec::Requests, type: :request
        config.include ObjectView::Rspec::Setup, type: :view
        config.include ObjectView::Rspec::Views, type: :view
        RUBY
        after_tgt = "# config.filter_gems_from_backtrace(\"gem name\")\n"
        inject_into_file "spec/rails_helper.rb",
                         "\n"+includes.gsub(/^/, "  "),
                         after: after_tgt
      end
    end

    private

    def factory_attributes(src)
      attributes_map(class_name) do |attr, type|
        "#{attr} { #{src[type.type].inspect} }"
      end.join("\n")
    end
  end
end
