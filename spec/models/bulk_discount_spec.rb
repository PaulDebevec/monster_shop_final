require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe "Validations" do
    it {validates_presence_of :name}
    it {validates_presence_of :description}
    it {validates_presence_of :discount_percentage}
    it {validates_presence_of :item_count_threshold}
  end
end
