class ComponentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_component, only: [:show, :edit, :update, :destroy]
  before_action :get_data, only: [:index, :show]

  # GET /components
  def index
  end

  # GET /components/1
  def show
    @packages = Component.all
  end

  # GET /components/new
  def new
    unless params[:parent_id].nil?
      @component = Component.new(parent_id: params[:parent_id])
      @prefix = Component.find_by_id(params[:parent_id]).full_title
    else
      @component = Component.new()
      @prefix = "Root::";
    end
  end

  # GET /components/1/edit
  def edit
    @prefix = ""
    component = Component.find_by_id(params[:id])
    component.ancestors.each do |parent|
      @prefix += parent.title + "::"
    end
  end

  # POST /components
  def create

    @component = Component.new(component_params)

    if @component.save
      redirect_to @component, notice: 'Component was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      @component.package_ids = params[:component][:package_ids] unless params[:component][:package_ids].blank?
      @component.save
      redirect_to @component, notice: 'Component was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /components/1
  def destroy
    @component.destroy
    redirect_to components_url, notice: 'Component was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component.find(params[:id])
    end

    def get_data
      @components = Component.all
      @frontend = [] unless @frontend
      @backend = [] unless @backend
      @other = [] unless @other
      @components.each do |u|
        if( u.full_title.split('::')[0] == "Front-end")
          @frontend << u
        else
          if( u.full_title.split('::')[0] == "Back-end")
            @backend << u
          else
            @other << u
          end
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def component_params
      params.require(:component).permit(:title, :description, :use, :graph, :package_id, :ancestry, :parent_id)
    end
end
