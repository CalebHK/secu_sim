class Order < ApplicationRecord
  belongs_to :account
  belongs_to :security
  validates :account_id, presence: true
  validates :code, presence: true, length: { maximum: 6 }
end
