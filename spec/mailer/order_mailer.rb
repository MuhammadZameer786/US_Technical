# spec/mailers/order_mailer_spec.rb
require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "order_confirmation" do
    let(:user) { User.create(email: "test@example.com", name: "Zameer") }
    let(:order) { Order.create(user: user, order_number: "CONF-123") }
    let(:mail) { OrderMailer.order_confirmation(order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Order Confirmation - CONF-123")
      expect(mail.to).to eq([ "test@example.com" ])
      expect(mail.from).to eq([ "from@example.com" ]) # Update this to your default 'from'
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thank you for your order")
      expect(mail.body.encoded).to match("CONF-123")
    end
  end
end
