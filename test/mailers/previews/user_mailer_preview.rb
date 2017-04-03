# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://secusim-calebhk.c9users.io/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://secusim-calebhk.c9users.io/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  # Preview this email at
  # http://secusim-calebhk.c9users.io/rails/mailers/user_mailer/security_account_activation
  def security_account_activation
    account = Account.first
    account.activation_token = User.new_token
    UserMailer.security_account_activation(account)
  end
end
