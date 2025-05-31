require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TablesHelper. For example:
#
# describe TablesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  RSpec.describe TablesHelper, type: :helper do
    # RSpec automatically loads ButtonHelper, but not the rest
    # so we do it explicitly
    #include ObjectView::ApplicationHelper

    let(:object) { create(:person) }
    it { assert_table(Person, object) { helper.ov_table(Person, [object]) } }
  end
end
