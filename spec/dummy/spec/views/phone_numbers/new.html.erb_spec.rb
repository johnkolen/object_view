require 'rails_helper'

RSpec.describe "phone_numbers/new", type: :view do
  viewsSetup object: :build_phone_number,
            user: :admin_user

  views_new
end
