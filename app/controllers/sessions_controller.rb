class SessionsController < ApplicationController
  def new; end

  def create
    # instance variable to use  in test by assign
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      log_in @user # set session
      remember_or_not params[:session][:remember_me], @user
      # can login page is derected when access edit page but hasn't login
      redirect_back_or @user # check page need direct
    else
      # use flash.now to display flash messages on rendered pages when direct
      # will lost
      flash.now[:danger] = t "controller.session.error"
      render :new
    end
  end

  def destroy
    log_out if logged_in? # a lot of tag, logout 1 tag, logout tag 2 not error
    redirect_to root_url
  end

  def remember_or_not checkbox_status, user
    checkbox_status == "1" ? remember(user) : forget(user)
  end
end
