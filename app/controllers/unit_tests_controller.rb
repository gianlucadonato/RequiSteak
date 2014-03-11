class UnitTestsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_unit_test, only: [:show, :edit, :update, :destroy]

  # GET /unit_tests
  def index
    @unit_tests = UnitTest.all
  end

  # GET /unit_tests/1
  def show
  end

  # GET /unit_tests/new
  def new
    @unit_test = UnitTest.new
    @unit_test.title = "TU - " + (UnitTest.all.length + 1).to_s
  end

  # GET /unit_tests/1/edit
  def edit
  end

  # POST /unit_tests
  def create
    if !params[:class_id].empty?
      @class = Unit.find_by_id(params[:class_id])
      @unit_test = UnitTest.new(unit_test_params)
      if @unit_test.save
        @class.unit_test = @unit_test
        @class.save
        redirect_to @class, notice: "Unit Test successfully added"
      else
        render action: 'new'
      end
    elsif !params[:unit_method_id].empty?
      @method = UnitMethod.find_by_id(params[:unit_method_id])
      @unit_test = UnitTest.new(unit_test_params)
      if @unit_test.save
        @method.unit_test = @unit_test
        @method.save
        redirect_to @method, notice: "Unit Test successfully added"
      else
        render action: 'new'
      end
    else
      @unit_test = UnitTest.new(unit_test_params)
      if @unit_test.save
        redirect_to @unit_test, notice: 'Unit test was successfully created.'
      else
        render action: 'new'
      end
    end
  end

  # PATCH/PUT /unit_tests/1
  def update
    if @unit_test.update(unit_test_params)
      @unit_test.unit_ids = params[:unit_test][:unit_ids] unless params[:unit_test][:unit_ids].blank?
      @unit_test.unit_method_ids = params[:unit_test][:unit_method_ids] unless params[:unit_test][:unit_method_ids].blank?
      @unit_test.save
      redirect_to @unit_test, notice: 'Unit test was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /unit_tests/1
  def destroy
    @unit_test.destroy
    redirect_to unit_tests_url, notice: 'Unit test was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_test
      @unit_test = UnitTest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_test_params
      params.require(:unit_test).permit(:title, :status, :description, :class_id, :unit_method_id)
    end
end
