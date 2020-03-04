require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it { should validate_inclusion_of(:discount_percentage).in_range(0..99) }
    it {should validate_presence_of :item_count_threshold}
  end
end
