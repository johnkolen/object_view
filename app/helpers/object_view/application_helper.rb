module ObjectView
  module ApplicationHelper
    # puts "loading ObjectView::ApplicationHellper"
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
    include Pagy::Frontend
  end
end
