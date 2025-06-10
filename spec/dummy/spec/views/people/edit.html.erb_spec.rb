require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  viewsSetup object: :create_person,
            user: :admin_user

  views_edit
end
