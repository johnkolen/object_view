require 'rails_helper'

RSpec.describe "people/new", type: :view do
  viewsSetup object: :build_person,
            user: :admin_user

  views_new
end
