class RequirementsController < ApplicationController
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  # GET /requirements
  def index
    @funzionali = Requirement.where({typology: "1"}).sort!{ |a,b| confronta(a,b) }
    @qualita = Requirement.where({typology: "3"}).sort!{ |a,b| confronta(a,b) }
    @vincolo = Requirement.where({typology: "4"}).sort!{ |a,b| confronta(a,b) }
  end

  # GET /requirements/1
  def show
    @UCU = UseCase.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
    @UCS = UseCase.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
    @UCM = UseCase.where({system: "M"}).sort!{ |a,b| confronta(a,b) }
    # Calcolo il prefisso da passare con GET alla new 
    unless @requirement.system.nil?
      @prefix = "R" + @requirement.system + @requirement.typology + @requirement.priority 
    else
      @prefix = "R" + @requirement.typology + @requirement.priority
    end    
  end

  # GET /requirements/new
  def new
    unless params[:parent_id].nil?
      @requirement = Requirement.new(:parent_id => params[:parent_id],
                                     :system => params[:system],
                                     :typology => params[:typology],
                                     :priority => params[:priority],
                                     :title => params[:title],
                                     :hierarchy => params[:hierarchy],
                                     :status => params[:status])
      @prefix = params[:title]
      @hierarchy = params[:hierarchy] + ".? "
    else
      @requirement = Requirement.new()
      @requirement.ancestry = 0
      @prefix = "RXYZ"
      @hierarchy = "0"
    end
  end

  # GET /requirements/1/edit
  def edit
    @prefix = "R" + @requirement.system + @requirement.typology + @requirement.priority
    @hierarchy = @requirement.hierarchy
  end

  # POST /requirements
  def create
    @requirement = Requirement.new(requirement_params)
  
    if @requirement.save
      unless params[:requirement][:system].nil? 
        @requirement.title = "R" + params[:requirement][:system] + params[:requirement][:typology] + 
                                   params[:requirement][:priority] + "\ " + params[:requirement][:hierarchy] 
      else
        @requirement.title = "R" + params[:requirement][:typology] + params[:requirement][:priority] + "\ " + params[:requirement][:hierarchy]
      end
      @requirement.save
      redirect_to @requirement, notice: 'Requirement was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /requirements/1
  def update
    if @requirement.update(requirement_params)
      unless params[:requirement][:system].nil? 
        @requirement.title = "R" + params[:requirement][:system] + params[:requirement][:typology] + 
                                   params[:requirement][:priority] + "\ " + params[:requirement][:hierarchy] 
      else
        @requirement.title = "R" + params[:requirement][:typology] + params[:requirement][:priority] + "\ " + params[:requirement][:hierarchy]
      end
      @requirement.use_case_ids = params[:requirement][:use_case_ids] unless params[:requirement][:use_case_ids].blank?
      @requirement.save
      redirect_to @requirement, notice: 'Requirement was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /requirements/1
  def destroy
    @requirement.destroy
    redirect_to requirements_url, notice: 'Requirement was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requirement
      @requirement = Requirement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def requirement_params
      params.require(:requirement).permit(:system, :typology, :priority, :hierarchy, :title, :status, :description, :ancestry, :use_case_ids)
    end
end
