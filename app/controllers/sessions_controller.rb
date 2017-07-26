class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase # local var
    if user && user.authenticate(params[:session][:password])
      log_in user # set session
      redirect_to user # user_url(user)
    else
      flash.now[:danger] = t "controller.session.error"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
