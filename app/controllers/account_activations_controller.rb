# use when click to activation link in email
class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    # because user auto login after activated, so if continue click activation
    # link that haven't !user.activated? will login seccess,this is wrong
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      # display a temporary messsage on the page of the first direct
      flash[:success] = t"controller.acc_activation.edit.success"
      redirect_to user
    else
      flash[:danger] = t"controller.acc_activation.edit.danger"
      redirect_to root_url
    end
  end
end
