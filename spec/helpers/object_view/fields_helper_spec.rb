require "rails_helper"

module ObjectView
  RSpec.describe FieldsHelper, type: :helper do
    include ObjectView::ApplicationHelper

    context "has_many associations" do
      let(:object) { create(:person) }

      before do
        create(:phone_number, person: object)
        object.add_builds!
      end

      it "renders nested fields with Stimulus controller wiring" do
        html = fake_form elements: :only do
          helper.ov_fields_for(:phone_numbers) do
            helper.ov_string_field :number
          end
        end
        node = Nokogiri::HTML(html)
        assert_dom node, "ul.ov-fields-for[data-controller=?]", "ov-fields-for"
        assert_dom node, "ul[data-ov-fields-for-target=?]", "list"
        assert_dom node, "input.ov-hidden-destroy[disabled]"
        assert_dom node, "button[data-action=?]", "click->ov-fields-for#remove"
        assert_dom node, "template[data-ov-fields-for-target=?]", "template"
      end
    end

    context "one-to-one associations" do
      describe "belongs_to with inverse has_one" do
        let(:object) { create(:user, person: create(:person)) }

        it "renders nested person fields in the user form" do
          html = fake_form elements: :only do
            helper.ov_fields_for(:person) do
              helper.ov_string_field :name
            end
          end
          node = Nokogiri::HTML(html)
          assert_dom node, "input[name=?]", "user[person_attributes][name]"
        end
      end

      describe "has_one with inverse belongs_to" do
        let(:object) { create(:person) }

        it "builds and renders nested user fields in the person form" do
          html = fake_form elements: :only do
            helper.ov_fields_for(:user) do
              helper.ov_string_field :email
            end
          end
          node = Nokogiri::HTML(html)
          assert_dom node, "input[name=?]", "person[user_attributes][email]"
        end
      end

      describe "missing one-to-one association" do
        let(:object) { build(:user) }

        it "builds the associated record for nested fields" do
          html = fake_form elements: :only do
            helper.ov_fields_for(:person) do
              helper.ov_string_field :name
            end
          end
          expect(html).to include("user[person_attributes][name]")
        end
      end
    end
  end
end
