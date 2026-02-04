require 'rails_helper'

RSpec.describe "Placing an Order", type: :system do
  # This runs before the test to set up the data
  let!(:distributor) { Distributor.create!(name: "Test Dist", currency: "ZAR") }
let!(:user) { User.create!(email: "test@example.com", password: "password", distributor: distributor, user_type: "distributor") }
 let!(:product) { Product.create!(name: "Bio-Oil 60ml") }
  let!(:sku) { Sku.create!(product: product, distributor: distributor, price: 100.00, sku_code: "BO-TD-001", currency: "ZAR", name: product.name) }

  it "calculates the total price correctly for 2 pallets" do
    # 1. Logic check: (2 pallets * 4800 units * 100.00 price) = 960,000.00
    expected_total = 2 * OrderItem::UNITS_PER_PALLET * sku.price

    # 2. Simulate the Order Creation
    order = Order.create!(
      distributor: distributor,
      user: user,
      required_delivery_date: Date.tomorrow
    )

    item = order.order_items.create!(
      sku: sku,
      quantity: 2,
      unit_price: sku.price,
      total_price: (2 * OrderItem::UNITS_PER_PALLET * sku.price)
    )

    # 3. Verify the Calculation
    order.calculate_total_amount!

    expect(order.total_amount).to eq(expected_total)
    expect(order.total_amount).to eq(960000.00)
    puts "✅ Pallet Math Verified: R #{order.total_amount}"
  end

  # TEST 2: The "Edge Case" (User tries to order 0 pallets)
  # it "does not allow an order with zero quantity" do
  #   # Capture the count BEFORE we try to save
  #   initial_count = Order.count

  #   order = Order.new(distributor: distributor, user: user, required_delivery_date: Date.tomorrow)

  #   # We try to save without adding items
  #   # If your controller logic is correct, this shouldn't result in a new DB record
  #   order.save

  #   # Check that the count hasn't increased
  #   expect(Order.count).to eq(initial_count)
  # end
end
