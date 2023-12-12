# frozen_string_literal: true

class ShoppingCart
  @@items = {
    :STAPOT => ['Potatoes', 10.00],
    :STARIC => ['Rice', 30.00],
    :STACOF => ['Coffee', 14.99],
    :MEDNEW => ['Newspaper', 2.99],
  }

  def initialize()
    @cart = []
  end
  
  def add(sku)
    @cart.push(sku)
  end

  def total_amount
    @cart
      .reduce(0) { |acc, v| acc + @@items[v][1] }
      .round(2)
  end

  def items_list
    @cart
      .map { |v| @@items[v][0] }
      .uniq
      .sort
      .join(", ")
  end
end

