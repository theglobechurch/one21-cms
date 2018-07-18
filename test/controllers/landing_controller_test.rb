require 'test_helper'

class LandingControllerTest < ActionController::TestCase

  test 'landing page loads if not logged in' do
    get :index
    assert_response(:success)
  end

  test 'user model avalible to landing page' do
    get :index
    assert assigns(:resource)
    assert_equal "User", assigns(:resource).class.name
    assert_equal "churchadmin", assigns(:resource).role
  end

  test 'landing page redirects if logged in' do
    sign_in create(:user)
    get :index
    assert_response(:redirect)
    assert_redirected_to admin_index_path
  end

end
