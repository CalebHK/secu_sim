class SecurityAccountActivationsController < ApplicationController
  
  def edit
    account = Account.find(params[:account_id])
    if account && !account.activated? && account.authenticated?(:activation, params[:id])
      account.activate
      flash[:success] = "Security Account activated!"
      redirect_to current_user ? current_user : root_url
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
