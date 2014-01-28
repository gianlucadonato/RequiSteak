class SystemTestsController < ApplicationController
  before_action :set_system_test, only: [:show, :edit, :update, :destroy]

  # GET /system_tests
  def index
    @system_tests = SystemTest.all
  end

  # GET /system_tests/1
  def show
  end

  # GET /system_tests/new
  def new
    @system_test = SystemTest.new
  end

  # GET /system_tests/1/edit
  def edit
  end

  # POST /system_tests
  def create
    @system_test = SystemTest.new(system_test_params)

    if @system_test.save
      redirect_to @system_test, notice: 'System test was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /system_tests/1
  def update
    if @system_test.update(system_test_params)
      redirect_to @system_test, notice: 'System test was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /system_tests/1
  def destroy
    @system_test.destroy
    redirect_to system_tests_url, notice: 'System test was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_test
      @system_test = SystemTest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_test_params
      params.require(:system_test).permit(:title, :status, :description)
    end
end
