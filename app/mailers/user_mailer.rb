class UserMailer < ApplicationMailer
  
  # send activation email for user
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "SecuSim Account Activation"
  end
  
  # send password reset email for user
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "SecuSim Password Reset"
  end
  
  # send securiy account activation email for user
  def security_account_activation(account)
    @user = account.user
    @account = account
    mail to: @user.email, subject: "SecuSim Security Account [#{account.name}] Activation."
  end
  
  def stock_split(inventory, ratio)
    @inventory = inventory
    @account = @inventory.account
    @user = @account.user
    @ratio = ratio
    mail to: @user.email, subject: "Your Security [#{inventory.code}] in SecuSim has been splited."
  end
  
  def cash_dividend(inventory, div)
    @inventory = inventory
    @account = @inventory.account
    @user = @account.user
    @div = div
    mail to: @user.email, subject: "Your Security [#{inventory.code}] in SecuSim has been paid cash dividend."
  end
  
  def stock_dividend(inventory, ratio)
    @inventory = inventory
    @account = @inventory.account
    @user = @account.user
    @ratio = ratio
    mail to: @user.email, subject: "Your Security [#{inventory.code}] in SecuSim has been paid stock dividend."
  end
end
