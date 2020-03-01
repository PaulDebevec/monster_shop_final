class BulkDiscount < ApplicationRecord
  validates_presence_of :name, :description, :discount_percentage, :item_count_threshold

  belongs_to :merchant

end
