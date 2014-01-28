require 'test_helper'

class ValidationTestsControllerTest < ActionController::TestCase
  setup do
    @validation_test = validation_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validation_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validation_test" do
    assert_difference('ValidationTest.count') do
      post :create, validation_test: { description: @validation_test.description, status: @validation_test.status, title: @validation_test.title }
    end

    assert_redirected_to validation_test_path(assigns(:validation_test))
  end

  test "should show validation_test" do
    get :show, id: @validation_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @validation_test
    assert_response :success
  end

  test "should update validation_test" do
    patch :update, id: @validation_test, validation_test: { description: @validation_test.description, status: @validation_test.status, title: @validation_test.title }
    assert_redirected_to validation_test_path(assigns(:validation_test))
  end

  test "should destroy validation_test" do
    assert_difference('ValidationTest.count', -1) do
      delete :destroy, id: @validation_test
    end

    assert_redirected_to validation_tests_path
  end
end
