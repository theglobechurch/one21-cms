require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test 'redirects to landing page if not logged in' do
    get :index

    assert_response(:redirect)
    assert_redirected_to new_user_session_path
  end

  test 'redirects to create new church when user not linked' do
    sign_in create(:user)
    get :index

    assert_response(:redirect)
    assert_redirected_to new_church_path
    assert_equal "You must create your church before proceeding", flash[:notice]
  end

  test 'Fresh setup allocated everything correctly' do
    usr = create(:user, :churchadmin)
    sign_in usr
    get :index

    assert_response(:ok)

    assert assigns(:church)
    assert assigns(:guides)
    assert_equal usr.church.church_name, assigns(:church).church_name
    assert_equal 1, assigns(:guides).length
    assert_equal "Sermons", assigns(:guides)[0].guide_name
  end

end
