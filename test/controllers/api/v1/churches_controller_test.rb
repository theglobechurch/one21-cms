require 'test_helper'

class Api::V1::ChurchesControllerTest < ActionController::TestCase

  setup do
    create(:user, :churchadmin)
  end

  test 'index: no public churches should return empty' do
    get :index
    assert_response(:ok)
  end

  test 'index: schema is correct' do
    create_list(:church, 2, :verified)

    get :index
    assert_response(:ok)

    # check returns two
    assert_equal 2, json_response.size

    # check schema is right
    # assert_response_schema('posts/show.json')
  end

  test 'index: unverifed churches do not return' do
    create(:church, :verified)

    # assert two churches in the db
    ch = Church.all
    assert_equal 2, ch.count

    get :index
    assert_response(:ok)

    # assert output is one
    assert_equal 1, json_response.size
  end

end
