require 'test_helper'

class UnitTestsControllerTest < ActionController::TestCase
  setup do
    @unit_test = unit_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unit_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit_test" do
    assert_difference('UnitTest.count') do
      post :create, unit_test: { description: @unit_test.description, status: @unit_test.status, title: @unit_test.title }
    end

    assert_redirected_to unit_test_path(assigns(:unit_test))
  end

  test "should show unit_test" do
    get :show, id: @unit_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unit_test
    assert_response :success
  end

  test "should update unit_test" do
    patch :update, id: @unit_test, unit_test: { description: @unit_test.description, status: @unit_test.status, title: @unit_test.title }
    assert_redirected_to unit_test_path(assigns(:unit_test))
  end

  test "should destroy unit_test" do
    assert_difference('UnitTest.count', -1) do
      delete :destroy, id: @unit_test
    end

    assert_redirected_to unit_tests_path
  end
end
