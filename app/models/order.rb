class Order < ApplicationRecord
  has_paper_trail
  belongs_to :distributor
  belongs_to :user
  has_many :order_items, dependent: :destroy


  validates :order_number, presence: true, uniqueness: true
  validates :required_delivery_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :delivery_date_cannot_be_in_the_past


  enum :status, {
    pending: 0,
    confirmed: 1,
    processing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5
  }, default: :pending


  before_validation :generate_order_number, on: :create
after_commit :send_confirmation_email, on: :create





  def calculate_total
    self.total_amount = order_items.sum(&:total_price)
  end
  # Allow searching these specific columns
  def self.ransackable_attributes(auth_object = nil)
    [ "order_number", "total_amount", "required_delivery_date", "created_at" ]
  end

  # Allow searching across these relationships
  def self.ransackable_associations(auth_object = nil)
    [ "distributor", "user" ]
  end
  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def delivery_date_cannot_be_in_the_past
    if required_delivery_date.present? && required_delivery_date < Date.today
      errors.add(:required_delivery_date, "can't be in the past")
    end

def calculate_total_amount!
    # 1. Sum up the total_price of all associated order_items
    new_total = order_items.sum(:total_price)

    # 2. Update the total_amount column in the database
    update!(total_amount: new_total)
end
def send_confirmation_email
    # .deliver_later puts the email into a background queue
    OrderMailer.order_confirmation(self.reload).deliver_now
end
  end
end
