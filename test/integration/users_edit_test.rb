require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # pull user out of fixtures..
  # def setup
  #   @user = users(:michael)
  # end

  # test "unsuccesful edit" do
  #   get edit_user_path(@user)
  #   patch user_path(@user), user: { name:  "",
  #                              email: "user@invalid",
  #                              password:              "foo",
  #                              password_confirmation: "bar" }
  #  assert_template 'users/edit'
  # end

  # test "succesful edit" do
  #   get edit_user_path(@user)
  #   patch user_path(@user), user: { name:  "Foo Bar",
  #                              email: "foo@bar.com",
  #                              password:              "",
  #                              password_confirmation: "" }
  #  assert_not flash.empty? #flash message that it was success
  #   # asserting that its not empty.
  #  assert_redirected_to @user #redirect to profile page
  #  @user.reload
  #  assert_equal @user.name, "Foo Bar"
  #  assert_equal @user.email, "foo@bar.com"
  # end

  def setup
    @user = users(:michael)
  end

  # test "unsuccessful edit" do
  #   log_in_as(@user)
  #   get edit_user_path(@user)
  #   assert_template 'users/edit'
  #   patch user_path(@user), user: { name:  "",
  #                                   email: "foo@invalid",
  #                                   password:              "foo",
  #                                   password_confirmation: "bar" }
  #   assert_template 'users/edit'
  # end

   test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end


end
