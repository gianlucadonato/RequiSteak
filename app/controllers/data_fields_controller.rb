class DataFieldsController < ApplicationController
  before_action :set_data_field, only: [:show, :edit, :update, :destroy]

  # GET /data_fields
  def index
    @data_fields = DataField.all
  end

  # GET /data_fields/1
  def show
  end

  # GET /data_fields/new
  def new
    @data_field = DataField.new(unit_id: params[:unit_id])
  end

  # GET /data_fields/1/edit
  def edit
  end

  # POST /data_fields
  def create
    @data_field = DataField.new(data_field_params)

    if @data_field.save
      redirect_to @data_field, notice: 'Data field was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /data_fields/1
  def update
    if @data_field.update(data_field_params)
      redirect_to @data_field, notice: 'Data field was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /data_fields/1
  def destroy
    @data_field.destroy
    redirect_to data_fields_url, notice: 'Data field was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_field
      @data_field = DataField.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def data_field_params
      params.require(:data_field).permit(:name, :visibility, :data_type, :description, :unit_id)
    end
end
