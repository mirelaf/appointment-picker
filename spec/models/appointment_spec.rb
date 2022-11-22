require "rails_helper"

RSpec.describe Appointment, type: :model do
  context 'validations' do
    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }
  end
end