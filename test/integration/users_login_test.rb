require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    # pulls the user michael out of the users yaml file ..test - fixtures-users.yml
    @user = users(:michael)
  end


# we need a test to capture the sequence shown in Figure 8.5 and Figure 8.6. The basic steps appear as follows:
# Visit the login path.
# Verify that the new sessions form renders properly.
# Post to the sessions path with an invalid params hash.
# Verify that the new sessions form gets re-rendered and that a flash message appears.
# Visit another page (such as the Home page).
# Verify that the flash message doesn’t appear on the new page.

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # test "login with valid information followed by logout" do
  #   get login_path
  #   post login_path, session: { email: @user.email, password: "password" }
  #   # we want valid emial and pw from db..
  #   # no user data in db.. so create fixtures for tests.. in our test-fixtures-users.yml
  #   # need to add password_digest method to user model.. up above our tests in setup..
  #     # then set our session hash here to @user.email and string "password"
  #   # our password_digest in our yaml file.. we need to create a class method on user in order to access this.. so in our users model,

  #   # user should be logged in..
  #   assert is_logged_in?

  #   # now we got the digest password, we direct to user profile page..
  #   assert_redirected_to @user
  #   # now follow the redirect..
  #   follow_redirect!
  #   # now render show page for user..
  #   assert_template 'users/show'
  #   # now we want login link to disappear so assert that there is no such link.. count 0 means that there arent any..
  #   assert_select "a[href=?]", login_path, count: 0
  #   # and we want logout path and profile path to appear so we do the following..
  #   assert_select "a[href=?]", logout_path
  #   assert_select "a[href=?]", user_path(@user)

  #   # should log user out
  #   delete logout_path

  #   assert_not is_logged_in?

  #   assert_redirected_to root_url

  # similate a user clicking logout in a second window..
  # delete logout_path

  #   # now check to see links changed back to normal after the redirect..
  #   follow_redirect!
  #   assert_select "a[href=?]", login_path
  #   assert_select "a[href=?]", logout_path, count: 0
  #   assert_select "a[href=?]", user_path(@user), count: 0
  # end

   test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # similate a user clicking logout in a second window..
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering checkbox" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering checkbox" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
