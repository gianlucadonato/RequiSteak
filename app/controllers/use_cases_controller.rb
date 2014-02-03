class UseCasesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_use_case, only: [:show, :edit, :update, :destroy]

  # GET /use_cases
  def index
    @UCU = UseCase.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
    @UCS = UseCase.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
    @UCM = UseCase.where({system: "M"}).sort!{ |a,b| confronta(a,b) }  
  end

  # GET /use_cases/1
  def show
    if !@use_case.system.nil?
      @prefix = "UC" + @use_case.system
    end 
  end

  # GET /use_cases/new
  def new
    unless params[:parent_id].nil?
      @use_case = UseCase.new(:parent_id => params[:parent_id], :system => params[:system], 
                              :hierarchy => params[:hierarchy],:title => params[:title])
      @prefix = params[:title]
      @hierarchy = params[:hierarchy] + ".? "
    else
      @use_case = UseCase.new()
      @use_case.ancestry = 0
      @prefix = "UCX"
      @hierarchy = "0"
    end
  end

  # GET /use_cases/1/edit
  def edit
    @prefix = "UC" + @use_case.system
    @hierarchy = @use_case.hierarchy
  end

  # POST /use_cases
  def create
    @use_case = UseCase.new(use_case_params)

    if @use_case.save
      @use_case.title = "UC" + params[:use_case][:system] + "\ " + params[:use_case][:hierarchy] + "\ - " + @use_case.subtitle 
      @use_case.save
      redirect_to @use_case, notice: 'Use case was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /use_cases/1
  def update
    if @use_case.update(use_case_params)
      @use_case.title = "UC" + params[:use_case][:system] + "\ " + params[:use_case][:hierarchy] + "\ - " + @use_case.subtitle 
      @use_case.save
      redirect_to @use_case, notice: 'Use case was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /use_cases/1
  def destroy
    @use_case.destroy
    redirect_to use_cases_url, notice: 'Use case was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_use_case
      @use_case = UseCase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def use_case_params
      params.require(:use_case).permit(:system, :hierarchy, :subtitle, :title, :primary_actors, :secondary_actors, :description, :precondition, :postcondition, :main_flow, :alternative_flow, :inclusion, :extension, :graph, :ancestry)
    end
end
