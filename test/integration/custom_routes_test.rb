require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "that the /login route opens the login page" do
  	get '/login'
  	assert_response :success
  end

  test "that the /login route redirects to root" do
  	get '/logout'
  	assert_response :redirect
  	assert_redirected_to '/'
  end

  test "that /register route opens the sign up page" do
  	get '/register'
  	assert_response :success
  end
end
