class Distributor < ApplicationRecord
  has_many :users
  has_many :skus
  has_many :orders

  validates :name, presence: true

  after_save :update_sku_currencies, if: :saved_change_to_currency?

  private

  def update_sku_currencies
    # This efficiently updates all related SKUs in one SQL query
    skus.update_all(currency: currency)
  end
end
