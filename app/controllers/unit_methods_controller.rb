class UnitMethodsController < ApplicationController
  before_action :set_unit_method, only: [:show, :edit, :update, :destroy]

  # GET /unit_methods
  def index
    @unit_methods = UnitMethod.all
  end

  # GET /unit_methods/1
  def show
  end

  # GET /unit_methods/new
  def new
    @unit_method = UnitMethod.new(unit_id: params[:unit_id])
  end

  # GET /unit_methods/1/edit
  def edit
  end

  # POST /unit_methods
  def create
    @unit_method = UnitMethod.new(unit_method_params)

    if @unit_method.save
      redirect_to @unit_method, notice: 'Unit method was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /unit_methods/1
  def update
    if @unit_method.update(unit_method_params)
      redirect_to @unit_method, notice: 'Unit method was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /unit_methods/1
  def destroy
    @unit_method.destroy
    redirect_to unit_methods_url, notice: 'Unit method was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_method
      @unit_method = UnitMethod.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_method_params
      params.require(:unit_method).permit(:name, :visibility, :isQuery, :return_type, :description, :unit_id)
    end
end
