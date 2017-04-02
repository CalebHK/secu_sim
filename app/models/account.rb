class Account < ApplicationRecord
  belongs_to :user
  default_scope -> { order(cash: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 14 }
end
