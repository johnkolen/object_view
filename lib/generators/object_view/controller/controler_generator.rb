module ObjectView
  class ControlerGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)
    def copy_template_files
      %w[controller].each do |x|
        template "#{x}.rb.tt",
                 "app/controller/#{name.pluralize}_controller.rb"
      end
    end
  end
end
