require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the FormsHelper. For example:
#
# describe FormsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  RSpec.describe FormsHelper, type: :helper do
    # RSpec automatically loads ButtonHelper, but not the rest
    # so we do it explicitly
    include ObjectView::ApplicationHelper

    let(:object) { User.new }
    context "total access form" do
      it "containing a single attribute" do
        assert_form object, :email do
          helper.ov_form object do
            helper.ov_text_field :email
          end
        end
      end
      it "containing a single attribute" do
        assert_form object, :name do
          helper.ov_form object do
            helper.ov_text_field :name
          end
        end
      end
    end
  end
end
