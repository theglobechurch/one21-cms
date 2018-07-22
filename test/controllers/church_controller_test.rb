require 'test_helper'

class ChurchesControllerTest < ActionController::TestCase
  test 'churchadmin redirects to admin_path if church already created' do
    sign_in create(:user, :churchadmin)
    get :index

    assert_response(:redirect)
    assert_redirected_to admin_index_path
  end

  test 'user redirects to new church if none related' do
    sign_in create(:user)
    get :index

    assert_response(:redirect)
    assert_redirected_to new_church_path
  end

  test 'show route should redirect to admin hub' do
    usr = create(:user, :churchadmin)
    sign_in usr
    get :show, params: {id: usr.church}

    assert_response(:redirect)
    assert_redirected_to admin_index_path
  end

  test 'new should redirect to edit if church already created' do
    usr = create(:user, :churchadmin)
    sign_in usr
    get :new

    assert_response(:redirect)
    assert_redirected_to edit_church_path(usr.church)
  end

  test 'new church should load if user not related' do
    sign_in create(:user)
    get :new

    assert_response(:success)
  end

  test 'create new church' do
    usr = create(:user)
    sign_in usr

    post :create, params: {
      church: {
        church_name: 'Churchy church',
        email: 'info@churchy-church.church',
        url: 'https://churchy-church.church',
        city: 'LDN, UK'
      }
    }

    assert_response(:redirect)
    assert_redirected_to admin_index_path
    assert_equal 'Church created', flash[:notice]
    assert assigns(:church)
    assert_equal 'Churchy church', assigns(:church).church_name
  end
end
