require 'rails_helper'

RSpec.describe "phone_numbers/edit", type: :view do
  viewsSetup object: :create_phone_number,
            user: :admin_user

  views_edit
end
