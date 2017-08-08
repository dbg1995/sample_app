# ApplicationMailer class
class ApplicationMailer < ActionMailer::Base
  default from: "danh13t1@gmail.com" # default send in from this email
  layout "mailer" # all view use this layout
end
