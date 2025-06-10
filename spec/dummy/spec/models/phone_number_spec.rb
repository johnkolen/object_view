require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  it { expect(create(:phone_number)).to be_a PhoneNumber }
  it { expect(create(:phone_number_sample)).to be_a PhoneNumber }
end
