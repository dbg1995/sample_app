# use to send in mail
class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @greeting = t"mailer.user_mailer.acc_activation.greeting"
    # mail mothed use view creates content mail then return a mail for deliver_now
    # send in two kind of message are txt and html.
    # Instead of render a view and send it over the HTTP protocol,
    # mailer is send view through the email protocols
    mail to: @user.email, subject: t("mailer.user_mailer.acc_activation.sub")
  end

  def password_reset; end
end
