class Distributor < ApplicationRecord
has_many :users, dependent: :destroy, inverse_of: :distributor
has_many :skus
  has_many :orders

validates :name,  :currency, presence: true
accepts_nested_attributes_for :users

  after_save :update_sku_currencies, if: :saved_change_to_currency?
def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
end
  private

  def update_sku_currencies
    # This efficiently updates all related SKUs in one SQL query
    skus.update_all(currency: currency)
  end
end
