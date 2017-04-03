class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "SecuSim Account Activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "SecuSim Password Reset"
  end
  
  def security_account_activation(account)
    @user = account.user
    @account = account
    mail to: @user.email, subject: "SecuSim Security Account [#{account.name}] Activation."
  end
end
