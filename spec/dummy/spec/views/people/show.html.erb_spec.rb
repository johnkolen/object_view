require 'rails_helper'

RSpec.describe "people/show", type: :view do
  viewsSetup object: :create_person,
             user: :admin_user

  views_show
end
