class CreateBulkDiscount < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.string :description
      t.integer :discount_percentage
      t.integer :item_count_threshold
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
