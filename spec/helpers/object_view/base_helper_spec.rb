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
  class KlassTest
  end
  RSpec.describe BaseHelper, type: :helper do
    # RSpec automatically loads ButtonHelper, but not the rest
    # so we do it explicitly
    include ObjectView::ApplicationHelper

    let(:kt_obj) { KlassTest.new }
    it { helper.ov_obj = :obj; expect(helper.ov_obj).to eq :obj }
    it { helper.ov_form = :obj; expect(helper.get_ov_form).to eq :obj }
    it { helper.ov_access_class = :obj
      expect(helper.ov_access_class).to eq :obj }
    it { helper.ov_obj = kt_obj
      expect(helper.ov_obj_class_name_u).to eq "object_view/klass_test" }
    it { helper.ov_obj = kt_obj
      expect(helper.ov_obj_class_name_k).to eq "object-view/klass-test" }
    it { helper.ov_obj = kt_obj
      expect(helper.ov_obj_class_name_h).to eq "object view/klass test" }
    it do
      helper.ov_obj = :hold
      helper.ov_form = :hold_f
      helper._ov_hold_state do
        helper.ov_obj = :obj
        helper.ov_form = :form
        expect(helper.ov_obj).to eq :obj
        expect(helper.get_ov_form).to eq :form
      end
      expect(helper.ov_obj).to eq :hold
    end
    it do
      helper.ov_obj = Person.new
      expect(helper.ov_obj_path).to eq "/people"
    end
    it do
      obj = create(:user)
      expect(helper.ov_render(partial: _partial_form(obj),
                              locals: _locals(obj))).to match /ov-form-wrapper/
    ensure
      obj.destroy
    end
  end
end
