class Sku < ApplicationRecord
  belongs_to :product
  belongs_to :distributor
  has_many :order_items

  validates :name, presence: true
  validates :sku_code, presence: true, uniqueness: true

  before_validation :sync_currency_from_distributor

  scope :active, -> { where(discarded_at: nil) }


  private

  def soft_delete
    update(discarded_at(Time.current))
  end
  def set_name_from_product
    self.name = product.name if product && name.blank?
  end

  def sync_currency_from_distributor
    self.currency = distributor&.currency
  end

  def price_for_distributor(distributor)
    skus.find_by(distributor: distributor)&.price
  end
  def active!
  end
end
