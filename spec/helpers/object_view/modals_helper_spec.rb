require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ModalsHelper. For example:
#
# describe ModalsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  RSpec.describe ModalsHelper, type: :helper do
    context "with existing objects" do
      let(:tc) { "<div>TURBO CONTENT<?div>" }
      let(:bc) { "<div>BODY CONTENT<?div>" }
      before :all do
        @person = create(:person)
      end
      after :all do
        @person.destroy
      end
      it { expect(helper.ov_modal_header).to match /ov-modal-header/ }
      it { expect(helper.ov_modal_body { }).to match /ov-modal-body/ }
      it { expect(helper.ov_modal_body { "fun" }).to match /fun/ }
      it { expect(helper.ov_modal_footer).to match /ov-modal-footer/ }

      it { expect(helper.ov_modal_objects_view(PhoneNumber, tc) { bc }).
             to match /BODY/}
      it { z = helper.ov_modal_objects_view(PhoneNumber,
                                            tc,
                                            turbo: true) { bc }
        expect(z).to match /TURBO/
        expect(z).to match /turbo-frame/
      }
      it { assert_modal { helper.ov_modal_objects(Person) { } } }
    end
  end

  context "with no existing objects" do
    it { expect(Person.first).to be_nil }
    it { assert_modal { helper.ov_modal_objects(Person) { } } }
  end
end
