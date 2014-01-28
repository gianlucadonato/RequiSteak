require 'test_helper'

class SystemTestsControllerTest < ActionController::TestCase
  setup do
    @system_test = system_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_test" do
    assert_difference('SystemTest.count') do
      post :create, system_test: { description: @system_test.description, status: @system_test.status, title: @system_test.title }
    end

    assert_redirected_to system_test_path(assigns(:system_test))
  end

  test "should show system_test" do
    get :show, id: @system_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_test
    assert_response :success
  end

  test "should update system_test" do
    patch :update, id: @system_test, system_test: { description: @system_test.description, status: @system_test.status, title: @system_test.title }
    assert_redirected_to system_test_path(assigns(:system_test))
  end

  test "should destroy system_test" do
    assert_difference('SystemTest.count', -1) do
      delete :destroy, id: @system_test
    end

    assert_redirected_to system_tests_path
  end
end
