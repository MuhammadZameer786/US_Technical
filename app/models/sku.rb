class Sku < ApplicationRecord
  belongs_to :product
  belongs_to :distributor
  has_many :order_items

  validates :name, presence: true
  validates :sku_code, presence: true, uniqueness: true

  private

  def set_name_from_product
    self.name = product.name if product && name.blank?
  end

  def price_for_distributor(distributor)
    skus.find_by(distributor: distributor)&.price
  end
end
