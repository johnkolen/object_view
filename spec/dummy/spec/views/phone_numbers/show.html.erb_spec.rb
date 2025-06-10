require 'rails_helper'

RSpec.describe "phone_numbers/show", type: :view do
  viewsSetup object: :create_phone_number,
             user: :admin_user

  views_show
end
