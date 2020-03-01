require 'rails_helper'

describe "Create New Bulk Discount" do
  describe "As a merchant" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it "On the merchant dashboard I see a link to Create Bulk Discount.
        That link takes me to a form to create a new discount" do

      visit '/merchant'

      click_link "Create Bulk Discount"
      expect(current_path).to eq('/merchant/bulk_discounts/new')

      fill_in :name, with: "August Sale"
      fill_in :description, with: "Sales for the month of August"
      fill_in :discount_percentage, with: 5
      fill_in :item_count_threshold, with: 10
      click_button "Submit"

      new_discount = BulkDiscount.last
      expect(current_path).to eq("/merchant/bulk_discounts/#{new_discount.id}")

      expect(page).to have_content("August Sale")
      expect(page).to have_content("Sales for the month of August")
      expect(page).to have_content("Discount: 5% off")
      expect(page).to have_content("Item Threshold: 10")
    end
  end
end
