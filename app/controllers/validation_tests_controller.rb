class ValidationTestsController < ApplicationController
  before_action :set_validation_test, only: [:show, :edit, :update, :destroy]

  # GET /validation_tests
  def index
    @validation_tests = ValidationTest.all
  end

  # GET /validation_tests/1
  def show
  end

  # GET /validation_tests/new
  def new
    @validation_test = ValidationTest.new
  end

  # GET /validation_tests/1/edit
  def edit
  end

  # POST /validation_tests
  def create
    @validation_test = ValidationTest.new(validation_test_params)

    if @validation_test.save
      redirect_to @validation_test, notice: 'Validation test was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /validation_tests/1
  def update
    if @validation_test.update(validation_test_params)
      redirect_to @validation_test, notice: 'Validation test was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /validation_tests/1
  def destroy
    @validation_test.destroy
    redirect_to validation_tests_url, notice: 'Validation test was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation_test
      @validation_test = ValidationTest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def validation_test_params
      params.require(:validation_test).permit(:title, :status, :description)
    end
end
