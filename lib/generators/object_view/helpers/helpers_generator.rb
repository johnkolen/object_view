require_relative "../generator_helpers"

class ObjectView::HelpersGenerator < Rails::Generators::Base
  include ObjectView::GeneratorHelpers

  source_root File.expand_path("templates", __dir__)
  def application_helpers
    unless grep? "app/helpers/application_helper.rb", "ObjectView"
      inject_into_module "app/helpers/application_helper.rb",
                         "ApplicationHelper",
                         "  include ObjectView::ApplicationHelper\n\n"
    end
  end
end
