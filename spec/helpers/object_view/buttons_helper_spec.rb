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
    # RSpec automatically loads ButtonHelper, but not the rest
    # so we do it explicitly
    include ObjectView::ApplicationHelper

    let(:object) { create(:person) }

    it { assert_button "Edit", edit_person_path(object), :get do
          helper.ov_edit(object)
        end}
    it { assert_button "Show", person_path(object), :get do
          helper.ov_show(object)
        end}
    it { assert_button "Delete", person_path(object), :delete do
          helper.ov_delete(object)
        end}
    it { assert_button "New", new_person_path(), :get do
          helper.ov_new(Person)
        end}
    it { assert_button "People", people_path(), :get do
          helper.ov_index(Person)
        end}
    it { assert_button "Add", nil, nil do
          fake_form elements: :only  do
            helper.ov_add
          end
        end}
    it { assert_button "Remove", nil, nil do
          fake_form elements: :only  do
            helper.ov_remove(5)
          end
        end}
    it { assert_button "Submit", nil, nil do
          ov_submit
        end}
  end
end
