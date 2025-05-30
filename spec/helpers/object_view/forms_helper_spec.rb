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
    it "calls formish" do
      expect(helper.respond_to? :ov_formish).to be true
      expect(helper.respond_to? :ov_form).to be true
    end
  end
end
