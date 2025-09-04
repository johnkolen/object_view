module ObjectView
  module ApplicationHelper
    # puts "loading ObjectView::ApplicationHellper"
    # ObjectView Helpers
    include BaseHelper
    include ButtonsHelper
    include DisplaysHelper
    include ElementsHelper
    include FieldsHelper
    include FormsHelper
    include MessagesHelper
    include NavigationHelper
    include ModalsHelper
    include TablesHelper

    # Suplimental Helpers
    include Pagy::Frontend
  end
end
