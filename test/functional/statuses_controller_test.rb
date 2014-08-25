require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should display user's posts when not logged in" do
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:mike).statuses.create(content: 'Non-blocked status')
    get :index

    assert_match /Non\-blocked status/, response.body
    assert_match /Blocked\ status/, response.body
  end

  test "should not display blocked user's posts when logged in" do
    sign_in users(:rose)
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:mike).statuses.create(content: 'Non-blocked status')
    get :index

    assert_match /Non\-blocked status/, response.body
    assert_no_match /Blocked\ status/, response.body
  end

  test "should be redirected when attempting to access the new status path while not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:rose)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:rose)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item for the status when logged in" do
    sign_in users(:rose)
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content }
    end
  end

  test "should create status for the current user when logged in" do
    sign_in users(:rose)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end
    
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:rose).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be redirected when attempting to edit a status when not signed in" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render edit page when signed in" do
    sign_in users(:rose)
    get :edit, id: @status
    assert_response :success
  end

  test "should not update status when not signed in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when signed in" do
    sign_in users(:rose)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item when the status is updated" do
    sign_in users(:rose)
    assert_difference 'Activity.count' do
      put :update, id: @status, status: { content: @status.content }
    end
  end

  test "should update status for the current user when signed in" do
    sign_in users(:rose)
    put :update, id: @status, status: { content: @status.content, user_id: users(:boatcat).id }
    assert_response :error
    assert_equal assigns(:status).user_id, users(:rose).id
  end

  test "should not update the status if nothing has changed" do
    sign_in users(:rose)
    put :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:rose).id
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
