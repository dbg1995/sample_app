module SessionsHelper
  def log_in user
    # Place a temporary cookie on the user's browser containing an encrypted
    # version of the user's id (1) to match with session on server, then on server
    # use session[:user_id] use the encrypted version of the user's id at client
    # to get corresponding user's id
    session[:user_id] = user.id # automatically encrypted
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by id: user_id
    elsif user_id = cookies.signed[:user_id] # auto decrypts the user id cookie
      user = User.find_by id: user_id
      # use remember_token to an attacker with both cookies can log in
      # only until the user logs out.
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget current_user # can't update_attribute here
    session.delete :user_id
    @current_user = nil
  end

  def remember user
    # save digest-token into database and set the remember token atribute
    user.remember
    # permanent 20 yeas, signed to encrypts, then place browser's cookie
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget # can't update_attribute here
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
