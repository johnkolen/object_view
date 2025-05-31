require 'rails_helper'

RSpec.describe "phone_numbers/edit", type: :view do
  let(:phone_number) {
    PhoneNumber.create!()
  }

  before(:each) do
    assign(:phone_number, phone_number)
  end

  it "renders the edit phone_number form" do
    render

    assert_select "form[action=?][method=?]", phone_number_path(phone_number), "post" do
    end
  end
end
