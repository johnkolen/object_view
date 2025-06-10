require 'rails_helper'

RSpec.describe "phone_numbers/index", type: :view do
  viewsSetup objects: [
               :create_phone_number_sample,
               :create_phone_number_sample
             ],
             user: :admin_user

  views_index
end
