class BulkDiscount < ApplicationRecord
  validates_presence_of :name, :description, :item_count_threshold
  validates_inclusion_of :discount_percentage, in: (0..99)

  belongs_to :merchant
end
