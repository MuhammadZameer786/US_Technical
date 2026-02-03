class Distributor < ApplicationRecord
  has_many :users
  has_many :skus
  has_many :orders

  validates :name, presence: true
end
