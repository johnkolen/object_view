require 'rails_helper'

module ObjectView
  RSpec.describe AccessAlways, type: :model do
    it { expect(AccessAlways.new).to be_a AccessAlways }
  end
end
