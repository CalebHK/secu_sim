class AccountsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      UserMailer.security_account_activation(@account).deliver_now
      flash[:info] = "Please check your email to activate your security account."
      redirect_to current_user
    else
      @news = news_feed("http://www.scmp.com/rss/2/feed")
      render 'static_pages/home'
    end
  end
  
  def show
    @account = Account.find(params[:id])
    @order = @account.orders.build
    @today_orders = @account.orders.where("created_at >= ?", hk_today_midnight)
                                 .where("created_at <= ?", hk_tmr_midnight)
    @processing_orders = @today_orders.where("order_type != ?", "cancel")
                                      .where("executed == ?", false)
    @done_orders = @today_orders.where("order_type != ?", "cancel")
                                      .where("executed == ?", true)
    redirect_to root_url and return unless @account.activated
  end

  def destroy
  end
  
  def bunch
    Account.each do |account|
      @orders = account.orders.where("created_at >= ?", hk_today_midnight)
                              .where("created_at <= ?", hk_tmr_midnight)
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

    def account_params
      params.require(:account).permit(:name)
    end
end
