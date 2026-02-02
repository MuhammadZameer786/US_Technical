class Distributor < ApplicationRecord
  has_many :users
  has_many :distributor_skus, dependent: :destroy
  has_many :skus, through: :distributor_skus
  has_many :orders

  validates :name, presence: true
end
