# ApplicationController class include Application helper => all controller more
# specific all view can use it. In addition include Application layout => all
# view can user Application layout
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # to all view can use it
end
