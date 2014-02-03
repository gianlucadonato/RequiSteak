class UnitsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  def index
    @units = Unit.all
  end

  # GET /units/1
  def show
    @units = Unit.all
    @components = Component.all
    if !@unit.component_id.nil?
      @component = Component.find_by_id(@unit.component_id)
    end
    @frontend = [] unless @frontend
    @backend = [] unless @backend
    @units.each do |u|
      if( u.title.split('::')[0] == "Front-end")
        @frontend << u
      else
        @backend << u
      end
    end
  end

  # GET /units/new
  def new
    unless params[:component_id].nil? 
      if !params[:parent_id].nil?
        @unit = Unit.new(parent_id: params[:parent_id], component_id: params[:component_id])
        @unit.title = Unit.find_by_id(params[:parent_id]).title + "::?"
      else
        @unit = Unit.new(component_id: params[:component_id])
        @unit.title = Component.find_by_id(params[:component_id]).title + "::?"
        @unit.ancestry = 0
      end
    else
      @unit = Unit.new()
      @unit.ancestry = 0
    end
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to @unit, notice: 'Unit was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.update(unit_params)
      @unit.unit_ids = params[:unit][:unit_ids] unless params[:unit][:unit_ids].blank?
      @unit.save
      redirect_to @unit, notice: 'Unit was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /units/1
  def destroy
    @unit.destroy
    redirect_to units_url, notice: 'Unit was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params.require(:unit).permit(:title, :description, :use, :component_id, :ancestry)
    end
end
