require 'rails_helper'

describe "Edit Bulk Discount" do
  describe "As a merchant" do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "Yoohoo", description: "Big Summer Blowout!", discount_percentage: 5, item_count_threshold: 10)
      @discount_2 = @merchant_1.bulk_discounts.create!(name: "10% Off Bulk Discount", description: "Buy 20 of an item, receive 10% off each item!", discount_percentage: 10, item_count_threshold: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it "On a merchant bulk discount show page I see a link to edit the discount.
        When I click this link I am redirected to a page with an edit form" do

      visit "/merchant/bulk_discounts/#{@discount_2.id}"
      click_link "Edit Bulk Discount"
      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount_2.id}/edit")

      fill_in :name, with: "August Sale"
      fill_in :description, with: "Sales for the month of August"
      fill_in :discount_percentage, with: 5
      fill_in :item_count_threshold, with: 10
      click_button "Save Changes"

      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount_2.id}")

      expect(page).to have_content("August Sale")
      expect(page).to have_content("Sales for the month of August")
      expect(page).to have_content("Discount: 5% off")
      expect(page).to have_content("Item Threshold: 10")
    end

    it "I see a flash message when I fail to fill in all fields" do

      visit "/merchant/bulk_discounts/#{@discount_1.id}"
      click_link "Edit Bulk Discount"
      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount_1.id}/edit")

      fill_in :name, with: "August Sale"
      fill_in :description, with: ""
      fill_in :discount_percentage, with: 5
      fill_in :item_count_threshold, with: 10
      click_button "Save Changes"

      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount_1.id}/edit")

      expect(page).to have_content("Description can't be blank")
    end
  end
end
