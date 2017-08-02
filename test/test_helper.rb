require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml
    # for all tests in alphabetical order.
    fixtures :all
    # Add more helper methods to be used by all tests here...
    include ApplicationHelper # inclue these help method to test it
    include SessionsHelper # to use helper method for test login status
  end
end
