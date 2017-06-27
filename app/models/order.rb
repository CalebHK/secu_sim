class Order < ApplicationRecord
  belongs_to :account
  validates :account_id, presence: true
  validates :code, presence: true, length: { maximum: 6 }
  validates :account_id, presence: true
end
