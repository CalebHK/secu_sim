class Account < ApplicationRecord
  attr_accessor :activation_token
  before_create :create_activation_digest
  belongs_to :user
  has_many :inventories, dependent: :destroy
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
  
  def bunch
    tdy = hk_today_midnight
    tmr = hk_tmr_midnight
    Account.all.each do |account|
      @orders = account.orders.where("created_at >= ?", tdy)
                              .where("created_at <= ?", tmr)
      @orders.group_by{|item| item[:code]}.each do |key, orders|
        net_cash = 0.0
        net_volume = 0
        un_net_cash = 0.0
        un_net_volume = 0
        # executed orders
        exe_orders = orders.group_by{|item| item[:executed]}[true]
        # executed buy orders
        exe_orders_buy = exe_orders.group_by{|item| item[:order_type]}["buy"]
        exe_orders_buy.each do |o|
          net_volume += o.volume
          net_cash -= o.volume*o.price
        end
        # executed sell orders
        exe_orders_sell = exe_orders.group_by{|item| item[:order_type]}["sell"]
        exe_orders_sell.each do |o|
          net_volume -= o.volume
          net_cash += o.volume*o.price
        end
        inv = account.inventories.where("code = ?", key).first
        inv.update_attributes(:volume => inv.volume + net_volume, :activated_volume => inv.activated_volume + net_volume, :cash => inv.cash + net_cash)
        
        # unexecuted orders
        unexe_orders = orders.group_by{|item| item[:executed]}[false]
        # unexecuted buy orders
        unexe_orders_buy = unexe_orders.group_by{|item| item[:order_type]}["buy"]
        unexe_orders_buy.each do |o|
          un_net_cash += o.volume*o.price
        end
        # unexecuted sell orders
        unexe_orders_sell = unexe_orders.group_by{|item| item[:order_type]}["sell"]
        unexe_orders_sell.each do |o|
          un_net_volume += o.volume
        end
        inv.update_attributes(:activated_volume => inv.activated_volume + un_net_volume, :cash => inv.cash + un_net_cash)
      end
    end
  end
  
  private

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
    def self.hk_today_midnight
      Date.today.midnight.in_time_zone("Hong Kong").utc
    end
    
    def self.hk_tmr_midnight
      hk_today_midnight + 1.day
    end
end
