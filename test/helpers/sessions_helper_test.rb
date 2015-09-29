require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    # want to hit current user branch where session is nil, but user has been remembered..
      # so pull a user out of the fixtures..
    assert_equal @user, current_user
      # we expect actual user to be equal to current user..
  end

  test "current user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
  end


end