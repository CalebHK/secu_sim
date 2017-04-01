class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "SecuSim Account Activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "SecuSim Password Reset"
  end
end
