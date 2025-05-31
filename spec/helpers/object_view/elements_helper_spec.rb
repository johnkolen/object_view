require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ElementsHelper. For example:
#
# describe ElementsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
module ObjectView
  context "text field" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_text_field(:name)
        assert_input elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_text_field(:name)
        assert_display elem, object, :name
      end
    end
  end

  context "string field" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_string_field(:name)
        assert_input elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_string_field(:name)
        assert_display elem, object, :name
      end
    end
  end

  context "integer field" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_integer_field(:name)
        assert_input elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_integer_field(:name)
        assert_display elem, object, :name
      end
    end
  end

  context "textarea" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_textarea(:name)
        assert_textarea elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_textarea(:name)
        assert_display elem, object, :name
      end
    end
  end

  context "password field" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_password_field(:name)
        assert_input elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_password_field(:name)
        assert_display elem, object, :name, div_class: "ov-password"
      end
    end
  end

  context "checkbox" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_checkbox(:name)
        assert_checkbox elem, object, :name
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_checkbox(:name)
        assert_checkbox elem, object, :name,
                        div_class: "ov-checkbox",
                        no_name: true do |node, klass|
          assert_dom node, "input[onclick=?]", "return false"
        end
      end
    end
  end

  context "date" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_date_field(:created_at)
        assert_date elem, object, :created_at
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_date_field(:created_at)
        assert_display elem, object, :created_at, div_class: "ov-date"
      end
    end
  end

  context "datetime" do
    let(:object) { Person.new }
    it "in form" do
      fake_form do
        elem = helper.ov_datetime_field(:created_at)
        assert_datetime elem, object, :created_at
      end
    end
    it "in display" do
      fake_display do
        elem = helper.ov_datetime_field(:created_at)
        assert_display elem, object, :created_at, div_class: "ov-datetime"
      end
    end
  end
end
