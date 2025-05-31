module ObjectView
  class ErbGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    def copy_files
      %w[edit index new show].each do |x|
        fname = "#{x}.html.erb"
        copy_file fname, "app/views/#{name.pluralize}/#{fname}"
      end
    end

    def copy_template_files
      %w[_form _table_row _object].each do |x|
        fname = "#{x}.html.erb"
        template "#{fname}.tt",
                 "app/views/#{name.pluralize}/#{fname}".
                   sub("object", name)
      end
    end
  end
end
