require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    # this says: compare before and after count and assume no difference or that it is the same as when it started.. bc of an invalid user save
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      # this post_via_redirect .. will follow the redirect after submission..
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    # we show the page..
    assert_template 'users/show'
    # we assert user is logged in... in test-testhelpers, we put in helper methods that get used in ALL the TESTS..
    assert is_logged_in?
  end



end