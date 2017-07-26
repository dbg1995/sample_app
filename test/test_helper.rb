require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml
    # for all tests in alphabetical order.
    fixtures :all
    include ApplicationHelper # inclue these help method to test it
    # include SessionsHelper # to use helper method for test login status
    # Add more helper methods to be used by all tests here...
    def is_logged_in? # check login status
      !session[:user_id].nil?
    end

    def log_in_as user
      session[:user_id] = user.id
    end

    class ActionDispatch::IntegrationTest
      # ":"" and "=" are default value, different is "=" only pass value when
      # call method and will auto pass it for left param. ":" need pass key and
      # value of param when call method and it pass correct involve param
      # login with checkbox remember me
      def log_in_as user, password: "password", remember_me: "1"
        post login_path, params: {
          session: {
            email: user.email, password: password, remember_me: remember_me
          }
        }
      end
    end
  end
end
