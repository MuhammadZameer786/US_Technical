require "rails_helper"

RSpec.describe Order, type: :model do
  let!(:distributor) { Distributor.create!(name: "Test Dist", currency: "ZAR") }
let!(:user) { User.create!(email: "test@example.com", password: "password", distributor: distributor, user_type: "distributor") }
 let!(:product) { Product.create!(name: "Bio-Oil 60ml") }
  let!(:sku) { Sku.create!(product: product, distributor: distributor, price: 100.00, sku_code: "BO-TD-001", currency: "ZAR", name: product.name) }


 describe "callbacks" do
  it "sends a confirmation email after creation" do
    expect {
      Order.create!(
        user: user,
        distributor: distributor,
        order_number: "US-#{SecureRandom.hex(4)}",
        required_delivery_date: Date.tomorrow,
        total_amount: 150.00,
        status: 0
      )
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    # Optional: Verify it was sent to the right person
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to include(user.email)
    expect(last_email.subject).to include("Order Confirmation")
    puts "Mailer sent. email#{user.email}    subject:#{last_email.subject}"
  end
end
end
