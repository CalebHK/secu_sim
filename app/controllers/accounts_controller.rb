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
  
  
  private

    def account_params
      params.require(:account).permit(:name)
    end
end
