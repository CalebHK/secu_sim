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
  
  def self.batch
    tdy = hk_today_midnight
    tmr = hk_tmr_midnight
    Account.all.each do |account|
      @orders = account.orders.where("created_at >= ?", tdy)
                              .where("created_at <= ?", tmr)
      if @orders.count > 0
        @orders.group_by{|item| item[:code]}.each do |key, orders|
          if orders.present?
            net_cash = 0.0
            net_volume = 0
            un_net_cash = 0.0
            un_net_volume = 0
            # executed orders
            exe_orders = orders.group_by{|item| item[:executed]}[true]
            if exe_orders.present?
              # executed buy orders
              exe_orders_buy = exe_orders.group_by{|item| item[:order_type]}["buy"]
              if exe_orders_buy.present?
                exe_orders_buy.each do |o|
                  net_volume += o.volume
                  net_cash -= o.volume*o.price
                end
              end
              # executed sell orders
              exe_orders_sell = exe_orders.group_by{|item| item[:order_type]}["sell"]
              if exe_orders_sell.present?
                exe_orders_sell.each do |o|
                  net_volume -= o.volume
                  net_cash += o.volume*o.price
                end
              end
              inv = account.inventories.where("code = ?", key).first
              inv.update_attributes(:volume => inv.volume + net_volume, :activated_volume => inv.activated_volume + net_volume)
              account.update_attributes(:cash => account.cash + net_cash)
            end
            
            # unexecuted orders
            unexe_orders = orders.group_by{|item| item[:executed]}[false]
            if unexe_orders.present?
              # unexecuted buy orders
              unexe_orders_buy = unexe_orders.group_by{|item| item[:order_type]}["buy"]
              if unexe_orders_buy.present?
                unexe_orders_buy.each do |o|
                  un_net_cash += o.volume*o.price
                end
              end
              # unexecuted sell orders
              unexe_orders_sell = unexe_orders.group_by{|item| item[:order_type]}["sell"]
              if unexe_orders_sell.present?
                unexe_orders_sell.each do |o|
                  un_net_volume += o.volume
                end
              end
              inv.update_attributes(:activated_volume => inv.activated_volume + un_net_volume)
              account.update_attributes(:cash => account.cash + un_net_cash)
            end
          end
        end
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
