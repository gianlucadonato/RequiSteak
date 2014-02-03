class IntegrationTestsController < ApplicationController
  before_action :set_integration_test, only: [:show, :edit, :update, :destroy]

  # GET /integration_tests
  def index
    @integration_tests = IntegrationTest.all
  end

  # GET /integration_tests/1
  def show
  end

  # GET /integration_tests/new
  def new
    @integration_test = IntegrationTest.new
    if !params[:comp_id].nil?
      comp = Component.find_by_id(params[:comp_id])
      @integration_test.title = "TI-" + comp.title
    end
  end

  # GET /integration_tests/1/edit
  def edit
  end

  # POST /integration_tests
  def create
    if !params[:comp_id].nil?
      @comp = Component.find_by_id(params[:comp_id])
      @integration_test = IntegrationTest.new(integration_test_params)
      if @integration_test.save
        @comp.integration_test = @integration_test
        @comp.save
        redirect_to @comp, notice: "Integration Test successfully added"
      else
        render action: 'new'
      end
    else
      @integration_test = IntegrationTest.new(integration_test_params)
      if @integration_test.save
        redirect_to @integration_test, notice: 'Integration test was successfully created.'
      else
        render action: 'new'
      end
    end
  end

  # PATCH/PUT /integration_tests/1
  def update
    if @integration_test.update(integration_test_params)
      @integration_test.component_ids = params[:integration_test][:component_ids]
      @integration_test.save
      redirect_to @integration_test, notice: 'Integration test was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /integration_tests/1
  def destroy
    @integration_test.destroy
    redirect_to integration_tests_url, notice: 'Integration test was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_integration_test
      @integration_test = IntegrationTest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def integration_test_params
      params.require(:integration_test).permit(:title, :status, :description)
    end
end
