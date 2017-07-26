module SessionsHelper
  def log_in user
    # Place a temporary cookie on the user's browser containing an encrypted
    # version of the user's id to match with session on server, then on server
    # use session[:user_id] and the encrypted version of the user's id at client
    # to get corresponding user's id
    session[:user_id] = user.id # automatically encrypted, exist at server
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    !session[:user_id].nil?
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end
end
