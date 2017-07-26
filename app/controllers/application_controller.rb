# include Application layout => all view can user it
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # to all controller more can use it
end
