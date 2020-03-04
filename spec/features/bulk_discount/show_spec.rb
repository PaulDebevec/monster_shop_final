require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do
  describe "As a merchant" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @merchant_user_2 = @merchant_2.users.create(name: 'James', address: '423 4th Ave', city: 'Fort Collins', state: 'CO', zip: 80538, email: 'James@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)
      @discount_2 = @merchant_1.bulk_discounts.create!(name: "10% Off Bulk Discount", description: "Buy 20 of an item, receive 10% off each item!", discount_percentage: 10, item_count_threshold: 20)
      @discount_3 = @merchant_2.bulk_discounts.create!(name: "Save 10% on Items for Bulk Orders", description: "Buy 20 of an item, receive 20% off each of those items", discount_percentage: 20, item_count_threshold: 20)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it "On the merchant dashboard I see the name of each discount is a link to it's show page" do
      visit '/merchant'

      within "#discount-#{@discount_1.id}" do
        click_link "#{@discount_1.name}"
      end

      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount_1.id}")

      expect(page).to have_content("#{@discount_1.name}")
      expect(page).to have_content("#{@discount_1.description}")
      expect(page).to have_content("Discount: #{@discount_1.discount_percentage}% off")
      expect(page).to have_content("Item Threshold: #{@discount_1.item_count_threshold}")

      expect(page).not_to have_content("#{@discount_2.name}")
      expect(page).not_to have_content("#{@discount_2.description}")
      expect(page).not_to have_content("Discount: #{@discount_3.discount_percentage}% off")
      expect(page).not_to have_content("Item Threshold: #{@discount_3.item_count_threshold}")
    end
  end
end
