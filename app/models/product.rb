class Product < ApplicationRecord
  has_many :skus, dependent: :destroy

  validates :name, presence: true
end
