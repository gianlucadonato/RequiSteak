require 'test_helper'

class UseCasesControllerTest < ActionController::TestCase
  setup do
    @use_case = use_cases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:use_cases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create use_case" do
    assert_difference('UseCase.count') do
      post :create, use_case: { alternative_flow: @use_case.alternative_flow, ancestry: @use_case.ancestry, description: @use_case.description, extension: @use_case.extension, graph: @use_case.graph, hierarchy: @use_case.hierarchy, inclusion: @use_case.inclusion, main_flow: @use_case.main_flow, postcondition: @use_case.postcondition, precondition: @use_case.precondition, primary_actors: @use_case.primary_actors, secondary_actors: @use_case.secondary_actors, system: @use_case.system, title: @use_case.title }
    end

    assert_redirected_to use_case_path(assigns(:use_case))
  end

  test "should show use_case" do
    get :show, id: @use_case
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @use_case
    assert_response :success
  end

  test "should update use_case" do
    patch :update, id: @use_case, use_case: { alternative_flow: @use_case.alternative_flow, ancestry: @use_case.ancestry, description: @use_case.description, extension: @use_case.extension, graph: @use_case.graph, hierarchy: @use_case.hierarchy, inclusion: @use_case.inclusion, main_flow: @use_case.main_flow, postcondition: @use_case.postcondition, precondition: @use_case.precondition, primary_actors: @use_case.primary_actors, secondary_actors: @use_case.secondary_actors, system: @use_case.system, title: @use_case.title }
    assert_redirected_to use_case_path(assigns(:use_case))
  end

  test "should destroy use_case" do
    assert_difference('UseCase.count', -1) do
      delete :destroy, id: @use_case
    end

    assert_redirected_to use_cases_path
  end
end
