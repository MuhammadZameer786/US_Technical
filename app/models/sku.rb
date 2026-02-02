class Sku < ApplicationRecord
  belongs_to :product
  has_many :distributor_skus, dependent: :destroy
  has_many :distributors, through: :distributor_skus
  has_many :order_items

  validates :name, presence: true
  validates :sku_code, presence: true, uniqueness: true

  def price_for_distributor(distributor)
    distributor_skus.find_by(distributor: distributor)&.price
  end
end
