require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"
require "rails/generators/resource_helpers"


module ObjectView
  # class ControllerGenerator < Rails::Generators::ScaffoldControllerGenerator
  class ControllerGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
    source_root File.expand_path("templates", __dir__)

    class_option :helper, type: :boolean

    class_option :orm, banner: "NAME", type: :string, required: true,
                 desc: "ORM to generate the controller for"

    class_option :skip_routes, type: :boolean,
                 desc: "Don't add routes to config/routes.rb."

    argument :attributes, type: :array,
             default: [], banner: "field:type field:type"

    def create_controller_files
      # template_file = options.api? ? "api_controller.rb" : "controller.rb"
      template_file = "controller.rb"
      template template_file,
               File.join("app/controllers",
                         controller_class_path,
                         "#{controller_file_name}_controller.rb")
    end

    def create_rest
      generate "object_view:erb", name
      inject_into :class, :ApplicationController,
                  "app/controllers/application_controller.rb",
                  "  include ObjectView::ControllerBase\n"
      inject_into :module, :ApplicationHelper,
                  "app/helpers/application_helper.rb",
                  "  include ObjectView::ApplicationHelper\n"
    end

    def create_helper_files
      template "helper.rb",
               File.join("app/helpers",
                         class_path,
                         "#{h_file_name}_helper.rb")
    end

    def add_resource_route
      return if options[:actions].present?
      route "resources :#{file_name.pluralize}", namespace: regular_class_path
    end

    hook_for :test_framework, as: :scaffold

    private
    def inject_into(kind, name, f,  t)
      File.open(f) do |file|
        unless file.read.match(/#{t}/m)
          send("inject_into_#{kind}", f, name.to_s, t)
        end
      end
    end

    def permitted_params
      klass = eval(class_name)
      # klass.attribute_types.each do |attr, type|
      klass.attribute_types.map(&:first).map(&:to_sym).
        difference([ :id, :created_at, :updated_at ]).
        map(&:inspect).join(", ")
    end

    def permitted_nested_params
      klass = eval(class_name)
      obj = klass.new
      klass.reflect_on_all_associations.inject({}) do |h, a|
        puts a.inspect
        puts a.plural_name
        na = "#{a.plural_name}_attributes"
        if true || obj.respond_to?("#{na}=")
          puts a.macro
          c = "#{a.plural_name}_controller".classify
          cx = Object.const_get(c) rescue nil
          if cx
            p = cx.send "#{a.plural_name.singularize}_params"
            p = p.union(%w[id _destroy])
            case a.macro
            when :has_many
              h[na.to_sym] = [ p.map(&:to_sym) ]
            when :has_one
              h[na.to_sym] = p.map(&:to_sym)
            end
            puts h.inspect
          end
        end
        puts "-" * 30
        h
      end.map { |k, v| "#{k}: #{v}" }.join(", ")
    end

    def attachments?(name)
      attribute = attributes.find { |attr| attr.name == name }
      attribute&.attachments?
    end
    def h_file_name
      @_file_name ||= file_name.sub(/_helper\z/i, "")
    end
  end
end
