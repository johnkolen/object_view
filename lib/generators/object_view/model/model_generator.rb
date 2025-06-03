require_relative "../generator_helpers"

class ObjectView::ModelGenerator < Rails::Generators::NamedBase
  include ObjectView::GeneratorHelpers

  source_root File.expand_path("templates", __dir__)
  def application_record
    unless grep? "app/models/application_record.rb", "ObjectView::Record"
      inject_into_class "app/models/application_record.rb",
                        "ApplicationRecord",
                        "  include ObjectView::Record\n\n"
    end
  end

  def update_model
    unless grep? "app/models/#{name}.rb", "ObjectView"
      inject_into_class "app/models/#{name}.rb",
                        name.classify,
                        "  include ObjectView::MetaAttributes\n" \
                        "  include ObjectView::Dims\n" \
                        "  include ObjectView::ToParams\n\n" \
    end
  end
end
