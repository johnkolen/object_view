require "rails_helper"

RSpec.describe "nested phone number destroy", type: :request do
  it "destroys a nested phone number via _destroy" do
    person = create(:person)
    phone = create(:phone_number, person: person)
    attrs = build(:person).to_params.slice(:name, :date_of_birth, :ssn, :age, :happy)
    attrs[:phone_numbers_attributes] = {
      "0" => { id: phone.id.to_s, _destroy: "1" }
    }

    expect {
      patch person_path(person), params: { person: attrs }
    }.to change(PhoneNumber, :count).by(-1)

    expect(response).to redirect_to(person_path(person))
  end
end
