ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    # we check if user is logged in by checking the session.. it should not be nil if he is logged in..
    !session[:user_id].nil?
      # this returns true if a test user is logged in.
  end

  # method to log users in, inside of test..
  def log_in_as(user, options = {})  #passing in hash of options..
    # so we pull out password and rememberme..
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
      # so if options remember me dont exist or nil, then give it 1

    # now 2 ways to log users in.. integration test and non integ tests..
    if integration_test?
      post login_path, session: {email: user.email,
                                 password: password,
                                 remember_me: remember_me }

    else
      # so for non integration tests:
      session[:user_id] = user.id
    end
  end

  private
    # returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
# now we can test the login function w 2 checkboxes remember me..

end