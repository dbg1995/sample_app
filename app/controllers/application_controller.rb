# include Application layout => all view can user it
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # to all controller more can use it

  def logged_in_user # fix access page need login before
    return if logged_in?
    store_location # store URL to access after login
    flash[:danger] = t"controller.user.logged_in_user.danger"
    redirect_to login_url
  end

  def correct_user # fix assess other user
    redirect_to root_url unless current_user? @user
  end

  def admin_user # check admin to delete user
    redirect_to root_url unless current_user.admin?
  end
end
