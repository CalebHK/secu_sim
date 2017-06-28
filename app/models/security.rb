class Security < ApplicationRecord
  has_many :orders
  has_many :inventories
  validates :code, presence: true, length: { maximum: 6 },
                   uniqueness: { case_sensitive: false }
  before_save   :upcase_code
                   
  def self.batch
    file_name = Date.today.to_s+".csv"
    tdy = hk_today_midnight
    tmr = hk_tmr_midnight
    CSV.open(Rails.root + "app/csv/" + file_name, "wb") do |csv|
      csv << ["CODE", "CASH_Balance", "VOLUME_balance"]
      Security.all.each do |security|
        net_volume = 0.0
        net_cash = 0.0
        orders = security.orders.where("created_at >= ?", tdy)
                                .where("created_at <= ?", tmr)
                                .where("executed = ?", true)
        if orders.count > 0
          orders.each do |order|
            if order.order_type == "buy"
              net_cash -= order.total_cost
              net_volume += order.volume
            else
              net_cash += order.total_cost
              net_volume -= order.volume
            end
          end
          # write to csv
          csv << [security.code, net_cash, net_volume]
        end
      end
    end
  end
  
  def split(ratio)
    self.inventories.each do |inv|
      inv.update_columns(volume: inv.volume * ratio, activated_volume: inv.activated_volume * ratio)
      UserMailer.stock_split(inv, ratio).deliver_now
    end
  end
  
  def cash_dividend(div)
    self.inventories.each do |inv|
      account = inv.account
      account.update_attribute(cash: account.cash + div * inv.activated_volume)
      UserMailer.stock_split(inv, div).deliver_now
    end
  end
  
  def stock_dividend(ratio)
    self.inventories.each do |inv|
      inv.update_columns(volume: inv.volume * (1 + ratio), activated_volume: inv.activated_volume * (1 + ratio))
      UserMailer.stock_dividend(inv, ratio).deliver_now
    end
  end
  
  private
    def self.hk_today_midnight
      Date.today.midnight.in_time_zone("Hong Kong").utc
    end
    
    def self.hk_tmr_midnight
      hk_today_midnight + 1.day
    end
    
    # Converts code to all upper-case.
    def upcase_code
      self.code = code.upcase
    end
end
