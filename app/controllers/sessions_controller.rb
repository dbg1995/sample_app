class SessionsController < ApplicationController
  def new; end

  def create
    # instance variable to use  in test by assign
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      log_in @user # set session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user # user_url(user)
    else
      flash.now[:danger] = t "controller.session.error" # direct will lost msg
      render :new
    end
  end

  def destroy
    log_out if logged_in? # a lot of tag, logout 1 tag, logout tag 2 not error
    redirect_to root_url
  end
end
