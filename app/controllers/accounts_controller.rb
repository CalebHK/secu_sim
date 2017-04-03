class AccountsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      UserMailer.security_account_activation(@account).deliver_now
      flash[:info] = "Please check your email to activate your security account."
      redirect_to current_user
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
  
  private

    def account_params
      params.require(:account).permit(:name)
    end
end
