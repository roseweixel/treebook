require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising an exception" do
  	assert_nothing_raised do
  		UserFriendship.create user: users(:rose), friend: users(:mike)
  	end
  end

	test "that creating a friendship based on user id and friend id works" do
		UserFriendship.create user_id: users(:rose).id, friend_id: users(:boatcat).id
		assert users(:rose).friends.include?(users(:boatcat))
	end
end
