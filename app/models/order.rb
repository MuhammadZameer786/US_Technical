class Order < ApplicationRecord
  belongs_to :distributor
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :order_number, presence: true, uniqueness: true
  validates :required_delivery_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_order_number, on: :create

  def calculate_total
    self.total_amount = order_items.sum(&:total_price)
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
