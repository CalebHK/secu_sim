class Order < ApplicationRecord
  belongs_to :account
  belongs_to :security
  validates :account_id, presence: true
  validates :code, presence: true, length: { maximum: 6 }
  before_save   :upcase_code
  
  private
    # Converts code to all upper-case.
    def upcase_code
      self.code = code.upcase
    end
end
