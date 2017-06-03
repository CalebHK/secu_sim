class Account < ApplicationRecord
  attr_accessor :activation_token
  before_create :create_activation_digest
  belongs_to :user
  has_many :inventories
  has_many :orders
  default_scope -> { order(cash: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 14 }
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  private

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
