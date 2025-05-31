require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MessagesHelper. For example:
#
# describe MessagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  RSpec.describe MessagesHelper, type: :helper do
    # RSpec automatically loads ButtonHelper, but not the rest
    # so we do it explicitly
    # include ObjectView::ApplicationHelper

    let(:object) { build(:person, ssn: "none") }

    it do
      object.save
      z = fake_form elements: :only do
        helper.ov_obj = object
        helper.ov_errors
      end
      expect(z).to match /ov-error/
      expect(z).to match /1 error/
      expect(z).to match /SSN/
    end
  end
end
