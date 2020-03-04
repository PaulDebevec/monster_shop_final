class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    quantity = @contents[item_id.to_s]
    quantity * item_discounted_price(item_id)
  end

  def item_discounted_price(item_id)
    discount = get_best_discount(item_id)
    item_price = Item.find(item_id).price
    item_price = discount.nil? ? item_price : apply_discount(discount, item_price)
  end

  def get_best_discount(item_id)
    item = self.items.find(item_id: item_id).first
    # discounts = item.merchant.bulk_discounts.where("item_count_threshold >= 'item_count'")
    discounts = item.merchant.bulk_discounts.select do |discount|
      count_of(item_id) >= discount.item_count_threshold
    end
    find_best_discount(discounts)
  end

  def find_best_discount(discounts)
    discounts.max_by {|discount| discount.item_count_threshold}
  end

  def apply_discount(discount, item_price)
    percentage = discount.discount_percentage / 100.to_f
    item_price - (item_price * percentage)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
