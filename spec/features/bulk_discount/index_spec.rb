require 'rails_helper'

RSpec.describe 'Item Index Page' do
  describe "As a merchant" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @merchant_user_2 = @merchant_2.users.create(name: 'James', address: '423 4th Ave', city: 'Fort Collins', state: 'CO', zip: 80538, email: 'James@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discount.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)
      @discount_2 = @merchant_1.discount.create!(name: "10% Off Bulk Discount", description: "Buy 20 of an item, receive 10% off each item!", discount_percentage: 10, item_count_threshold: 20)
      @discount_3 = @merchant_2.discount.create!(name: "Save 10% on Items for Bulk Orders", description: "Buy 20 of an item, receive 20% off each of those items", discount_percentage: 20, item_count_threshold: 20)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end
    it "At '/merchant' I see each discount belonging to that merchant" do
      visit '/merchant'

      within "#discount-#{@discount_1}" do
        expect(page).to have_content("Yoohoo")
        expect(page).to have_content("Big Summer Blowout!")
      end

      within "#discount-#{@discount_1}" do
        expect(page).to have_content("Yoohoo")
        expect(page).to have_content("Big Summer Blowout!")
      end

      expect(page).not_to have_content("Save 10% on Items for Bulk Orders")
      expect(page).not_to have_content("Buy 20 of an item, receive 20% off each of those items")
    end
  end
end
