require 'test_helper'

class IntegrationTestsControllerTest < ActionController::TestCase
  setup do
    @integration_test = integration_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:integration_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create integration_test" do
    assert_difference('IntegrationTest.count') do
      post :create, integration_test: { description: @integration_test.description, status: @integration_test.status, title: @integration_test.title }
    end

    assert_redirected_to integration_test_path(assigns(:integration_test))
  end

  test "should show integration_test" do
    get :show, id: @integration_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @integration_test
    assert_response :success
  end

  test "should update integration_test" do
    patch :update, id: @integration_test, integration_test: { description: @integration_test.description, status: @integration_test.status, title: @integration_test.title }
    assert_redirected_to integration_test_path(assigns(:integration_test))
  end

  test "should destroy integration_test" do
    assert_difference('IntegrationTest.count', -1) do
      delete :destroy, id: @integration_test
    end

    assert_redirected_to integration_tests_path
  end
end
