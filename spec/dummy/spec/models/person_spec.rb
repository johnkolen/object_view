require 'rails_helper'

RSpec.describe Person, type: :model do
  it { expect(create(:person)).to be_a Person }
  it { expect(create(:person_sample)).to be_a Person }
end
