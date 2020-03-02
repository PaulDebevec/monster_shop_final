require 'rails_helper'

RSpec.describe "Delete Bulk Discount" do
  describe "I can delete a bulk discount" do
    it "On the merchant bulk discounts index page" do
      merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      merchant_user = merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      discount_1 = merchant_1.bulk_discounts.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)
      discount_2 = merchant_1.bulk_discounts.create!(name: "10% Off Bulk Discount", description: "Buy 20 of an item, receive 10% off each item!", discount_percentage: 10, item_count_threshold: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchant'

      within "#discount-#{discount_2.id}" do
        click_link "Delete Discount"
      end

      expect(current_path).to eq('/merchant')

      expect(page).to have_content("Yoohoo")
      expect(page).to have_content("Big Summer Blowout!")
      expect(page).to have_content("Discount Deleted")

      expect(page).not_to have_content("10% Off Bulk Discount")
      expect(page).not_to have_content("Buy 20 of an item, receive 10% off each item!")
      expect(BulkDiscount.count).to eq(1)
    end

    it "On the merchant bulk discount show page" do
      merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      merchant_user = merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      discount_1 = merchant_1.bulk_discounts.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)
      discount_2 = merchant_1.bulk_discounts.create!(name: "10% Off Bulk Discount", description: "Buy 20 of an item, receive 10% off each item!", discount_percentage: 10, item_count_threshold: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/bulk_discounts/#{discount_1.id}"

      click_link "Delete Discount"

      expect(current_path).to eq('/merchant')

      expect(page).to have_content("10% Off Bulk Discount")
      expect(page).to have_content("Buy 20 of an item, receive 10% off each item!")

      expect(page).not_to have_content("Yoohoo")
      expect(page).not_to have_content("Big Summer Blowout!")
      expect(BulkDiscount.count).to eq(1)
    end
  end
end
