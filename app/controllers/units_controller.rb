class UnitsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  before_action :get_data, only: [:index, :show]

  # GET /units
  def index
  end

  # GET /units/1
  def show
    @components = Component.all
    if !@unit.component_id.nil?
      @component = Component.find_by_id(@unit.component_id)
    end
  end

  # GET /units/new
  def new
    @edit = false
    unless params[:component_id].nil? 
      if !params[:parent_id].nil?
        @unit = Unit.new(parent_id: params[:parent_id], component_id: params[:component_id])
        @prefix = @unit.component.full_title + "::"
      else
        @unit = Unit.new(component_id: params[:component_id])
        @prefix = @unit.component.full_title + "::"
      end
    else
      @unit = Unit.new()
      @prefix = "Root::"
      @unit.ancestry = 0
    end
  end

  # GET /units/1/edit
  def edit
    @edit = true
    if @unit.component
      @prefix = @unit.component.full_title + "::"
    else
      @prefix = "Root::"
    end 
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

    def get_data
      @units = Unit.all
      @frontend = [] unless @frontend
      @backend = [] unless @backend
      @other = [] unless @other
      @units.each do |u|
        if u.full_title.start_with?("Front")
          @frontend << u
        else
          if u.full_title.start_with?("Back")
            @backend << u
          else
            @other << u
          end
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params.require(:unit).permit(:title, :description, :use, :typology, :component_id, :ancestry, :parent_id)
    end
end
