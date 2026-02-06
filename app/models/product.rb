class Product < ApplicationRecord
  has_paper_trail
  has_many :skus, dependent: :destroy

  validates :name, presence: true

scope :active, -> { where(discarded_at: nil) }

  def soft_delete
    update!(discarded_at: Time.current)

    skus.update_all(discarded_at: Time.now)
  end

  def active?
    discarded_at.nil?
  end
end
