module ObjectView
  module ApplicationHelper
    puts "loading ObjectView::ApplicationHellper"
    include BaseHelper
    include ButtonsHelper
    include ElementsHelper
    include FieldsHelper
    include FormsHelper
    include MessagesHelper
    include ModalsHelper
  end
end
