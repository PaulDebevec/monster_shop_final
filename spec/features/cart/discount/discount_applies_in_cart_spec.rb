require 'rails_helper'

describe "As a default user or a merchant user" do
  describe "Discount applies when the count of an item in my cart is >= the item_count_threshold of a discount" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_user = @megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @megan.bulk_discounts.create!(name: "Yoohoo",
                                                  description: "Big Summer Blowout!",
                                                  discount_percentage: 10,
                                                  item_count_threshold: 10)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
    end

    it "When I add 10 of an item to my cart it automatically applies the associated coupon" do
      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit '/cart'

      within "#item-#{@ogre.id}" do
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
      end

      expect(page).to have_content("Total: $180.00")
      expect(page).to have_content("Price: $18.00")
      expect(page).to have_content("Discount Applied: #{@discount_1.name}")
    end
  end
end
