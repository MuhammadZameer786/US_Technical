class DistributorSku < ApplicationRecord
  belongs_to :distributor
  belongs_to :sku

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku_id, uniqueness: { scope: :distributor_id, message: "already assigned to this distributor" }
end
