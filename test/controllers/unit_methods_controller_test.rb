require 'test_helper'

class UnitMethodsControllerTest < ActionController::TestCase
  setup do
    @unit_method = unit_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unit_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit_method" do
    assert_difference('UnitMethod.count') do
      post :create, unit_method: { description: @unit_method.description, isQuery: @unit_method.isQuery, name: @unit_method.name, return_type: @unit_method.return_type, visibility: @unit_method.visibility }
    end

    assert_redirected_to unit_method_path(assigns(:unit_method))
  end

  test "should show unit_method" do
    get :show, id: @unit_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unit_method
    assert_response :success
  end

  test "should update unit_method" do
    patch :update, id: @unit_method, unit_method: { description: @unit_method.description, isQuery: @unit_method.isQuery, name: @unit_method.name, return_type: @unit_method.return_type, visibility: @unit_method.visibility }
    assert_redirected_to unit_method_path(assigns(:unit_method))
  end

  test "should destroy unit_method" do
    assert_difference('UnitMethod.count', -1) do
      delete :destroy, id: @unit_method
    end

    assert_redirected_to unit_methods_path
  end
end
