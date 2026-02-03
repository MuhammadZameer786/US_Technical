class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # before_validation :calculate_total_price
  UNITS_PER_PALLET = 4800

  private

  def calculate_total_price
    self.total_price = (quantity || 0) * (unit_price || 0) * UNITS_PER_PALLET
  end
end
