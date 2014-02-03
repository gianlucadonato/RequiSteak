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
      @component.title = Component.find_by_id(params[:parent_id]).title + "::?"
    else
      @component = Component.new()
      @component.ancestry = 0
    end
  end

  # GET /components/1/edit
  def edit
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

  def export
    file = "componenti-e-classi.tex"
    File.open(file, "wb+"){ |f|
      f << "\\section{Componenti e Classi}"
      
      comp = []
      frontend = Component.find_by_title("Front-end");
      if !frontend.nil?
        comp << frontend
        frontend.descendants.each do |c|
          comp << c
        end
      end
      backend = Component.find_by_title("Back-end");
      if !backend.nil?
        comp << backend
        backend.descendants.each do |c|
          comp << c
        end
      end
comp.each do |comp|      
  f << "
  \\subsection{#{comp.title}}
  \\subsubsection{Informazioni sul package} 

    \\begin{figure}[H] 
      \\begin{center} 
        %\\includegraphics[scale=1]{packages/NomePackage.png}  
        \\caption{Componente #{comp.title}}
      \\end{center}  
    \\end{figure} 

  \\paragraph{Descrizione} 
    \\begin{itemize}
    \\item[] #{comp.description}
    \\end{itemize} "

  if !comp.descendants.empty?
  f << "
    \\paragraph{Package contenuti} 
    \\begin{itemize}"
    comp.descendants.each do |pkg|  
      f << "
        \\item #{pkg.title}" 
    end
  f << "
    \\end{itemize}"
  end

  if !comp.packages.empty?  
  f<< "
  \\paragraph{Interazioni con altri componenti} %facoltativo 
    \\begin{itemize} "
    comp.packages.each do |pkg| 
      f << "
        \\item #{pkg.title}" 
    end
  f << "  
    \\end{itemize} "
  end

  if !comp.units.empty? 
    f<< "
    \\subsubsection{Classi}"
    comp.units.each do |u| 
      f << "
      \\paragraph{#{u.title}}
        
        \\textbf{\\\\ \\\\ Descrizione} 
          \\begin{itemize}
            \\item[] #{u.description}
          \\end{itemize}      
        \\textbf{Utilizzo}  
          \\begin{itemize}
            \\item[] #{u.use}
          \\end{itemize}" 
        if !u.ancestors.empty?
        f << "
          \\textbf{Classi Ereditate}
          \\begin{itemize}"
            u.ancestors.each do |p|
              f << "
                \\item{#{p.title}}"
            end
        f << "
          \\end{itemize}"
        end
        if !u.descendants.empty?  
        f << "
          \\textbf{Classi Figlie}
          \\begin{itemize}"
            u.descendants.each do |c|
              f << "
              \\item{#{c.title}}"
            end
        f << "
          \\end{itemize}"
        end
        if !u.units.empty?  
        f << "
          \\textbf{Relazioni con altre classi}
          \\begin{itemize}"
            u.units.each do |c|
              f << "
              \\item{#{c.title}}"
            end
        f << "
          \\end{itemize}"
        end
    end
  end
end #end comp.each
    }
    send_file(file)
  end #end export

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
        if( u.title.split('::')[0] == "Front-end")
          @frontend << u
        else
          if( u.title.split('::')[0] == "Back-end")
            @backend << u
          else
            @other << u
          end
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def component_params
      params.require(:component).permit(:title, :description, :use, :graph, :package_id, :ancestry)
    end
end
