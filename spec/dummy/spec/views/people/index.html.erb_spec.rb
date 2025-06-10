require 'rails_helper'

RSpec.describe "people/index", type: :view do
  viewsSetup objects: [
               :create_person_sample,
               :create_person_sample
             ],
             user: :admin_user

  views_index
end
