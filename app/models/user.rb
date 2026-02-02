class User < ApplicationRecord
  has_secure_password

  belongs_to :distributor, optional: true

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :user_type, presence: true, inclusion: { in: %w[admin distributor] }
  validates :distributor_id, presence: true, if: -> { user_type == 'distributor' }

  def admin?
    user_type == 'admin'
  end

  def distributor?
    user_type == 'distributor'
  end
end
