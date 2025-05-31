require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BaseHelper. For example:
#
# describe BaseHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  RSpec.describe ButtonsHelper, type: :helper do
    let(:person) { build(:person, id: 5) }
    it {assert_button "Edit", edit_person_path(person), :get do
          ov_edit(person)
        end}
  end
end
