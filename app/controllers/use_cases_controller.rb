class UseCasesController < ApplicationController
  before_action :set_use_case, only: [:show, :edit, :update, :destroy]
  before_action :get_ordered_data, only: [:index, :export]
  # GET /use_cases
  def index  
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

  def export

  file = "capitolo-casiduso.tex" 
  File.open(file, "wb+"){ |f| 

f << "\\section{Casi d'uso}
I casi d'uso seguenti emergono da un'attenta analisi degli \\textit{Analisti} del gruppo \\GroupName{} rivolta al capitolato e da un'approfondita discussione con il proponente \\Proponente{}. Gran parte dei casi d'uso sono stati dedotti grazie all'esperienza derivata dall'utilizzo di \\glossario{ActiveAdmin}, un progetto analogo a \\ProjectName{} basato su \\glossario{Ruby on Rails}.\\
Ogni caso d'uso è identificato univocamente e in modo gerarchico tramite una codifica nella forma:

\\begin{center}

\\textit{UC[codice dell'ambito][codice univoco del padre],[codice progressivo del figlio]}

\\end{center} 

dove il \\textbf{codice dell'ambito} può assumere i seguenti valori:

\\begin{itemize}

  \\item \\textbf{U} - ambito utente, che comprende sia l'utente normale che l'\\textit{admin} di una applicazione generata da \\ProjectName{};
  \\item \\textbf{S} - ambito sviluppatore.
  \\item \\textbf{M} - ambito utente \\glossario{MaaS} (MongoDB as an admin Service).

\\end{itemize}
Per i tre ambiti(Utente,Sviluppatore,\\glossario{MaaS}) il corrispondente diagramma delle \"Operazioni ad alto livello\" è stato suddiviso per tipologia di utente, mantenendo per comodità la nomenclatura che ci sarebbe stata se non avessimo effettuato la suddivisione.
Nei diagrammi dei casi d'uso, il sistema dei livelli di astrazione inferiore si riferisce in modo ricorsivo al sistema del caso d'uso del padre. 
Per comodità di lettura viene utilizzato il nome del caso d'uso in analisi. 


\\subsection{Ambito Utente}"
@UCU.each do |d|
f << "
\\subsubsection{#{d.title}} "
  if d.graph != ""  
  f <<"   
    \\begin{figure}[H]
      \\begin{center}
      \\includegraphics[width=12cm]{UML/#{d.title}.png}
      \\caption{#{d.title}}
      \\end{center} 
    \\end{figure}    
    "
  end
  f <<"
      %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}     
      \\begin{longtable}{  p{3.5cm} | p{8cm} } 
            
      \\hline
      \\multicolumn{2}{ | c | }{ \\cellcolor[gray]{0.9} \\textbf{#{d.title}}} \\\\ 
      \\hline
      
      \\textbf{Attori Primari} & #{d.primary_actors} \\\\ "
      if !d.secondary_actors.blank?
          f << "
          \\textbf{Attori Secondari} &  #{d.secondary_actors} \\\\"
      end    
      f << "
          \\textbf{Scopo e Descrizione} & #{d.description} \\\\ 
          
          \\textbf{Precondizioni}  & #{d.precondition}\\\\ 
          
          \\textbf{Postcondizioni} & #{d.postcondition} \\\\ "
      if !d.main_flow.blank?    
      f << "
          \\textbf{Flusso Principale} & #{d.main_flow} \\\\
          "
      end
      if !d.alternative_flow.blank?    
        f << " \\textbf{Scenari Alternativi} & #{d.alternative_flow} \\\\" 
      end
      if !d.inclusion.blank?   
        f << " \\textbf{Inclusioni} & #{d.inclusion} \\\\" 
      end
      if !d.extension.blank?  
        f << " \\textbf{Estensioni} & #{d.extension} \\\\" 
      end
      f << "
      \\end{longtable}
      \\egroup
\\end{center}
" 
end

f<<"\\subsection{Ambito Sviluppatore}"
@UCS.each do |d|
f << "
\\subsubsection{#{d.title}} "
  if d.graph != ""  
  f <<"
    \\begin{figure}[H]
      \\begin{center}
      \\includegraphics[width=12cm]{UML/#{d.title}.png}
      \\caption{#{d.title}}
      \\end{center} 
    \\end{figure}  
    "
  end
  f <<"
      %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}     
      \\begin{longtable}{  p{3.5cm} | p{8cm} } 
            
      \\hline
      \\multicolumn{2}{ | c | }{ \\cellcolor[gray]{0.9} \\textbf{#{d.title}}} \\\\ 
      \\hline
      
      \\textbf{Attori Primari} & #{d.primary_actors} \\\\ "
      if !d.secondary_actors.blank?
          f << "
          \\textbf{Attori Secondari} &  #{d.secondary_actors} \\\\"
      end    
      f << "
          \\textbf{Scopo e Descrizione} & #{d.description} \\\\ 
          
          \\textbf{Precondizioni}  & #{d.precondition}\\\\ 
          
          \\textbf{Postcondizioni} & #{d.postcondition} \\\\"
      if !d.main_flow.blank?    
      f << "
          \\textbf{Flusso Principale} & #{d.main_flow} \\\\
          "
      end
      if !d.alternative_flow.blank?    
        f << " \\textbf{Scenari Alternativi} & #{d.alternative_flow} \\\\" 
      end
      if !d.inclusion.blank?   
        f << " \\textbf{Inclusioni} & #{d.inclusion} \\\\" 
      end
      if !d.extension.blank?  
        f << " \\textbf{Esclusioni} & #{d.extension} \\\\" 
      end
      f << "
      \\end{longtable}
      \\egroup
\\end{center}
" 
end

f<<"\\subsection{Ambito Utente MaaS}"
@UCM.each do |d|
f << "
\\subsubsection{#{d.title}} "
  if d.uml_path != ""  
  f <<"
    \\begin{figure}[H]
      \\begin{center}
      \\includegraphics[width=12cm]{UML/#{d.title}.png}
      \\caption{#{d.title}}
      \\end{center} 
    \\end{figure}  
    "
  end
  f <<"
      %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}     
      \\begin{longtable}{  p{3.5cm} | p{8cm} } 
            
      \\hline
      \\multicolumn{2}{ | c | }{ \\cellcolor[gray]{0.9} \\textbf{#{d.title}}} \\\\ 
      \\hline
      
      \\textbf{Attori Primari} & #{d.primary_actors} \\\\ "
      if !d.secondary_actors.blank?
          f << "
          \\textbf{Attori Secondari} &  #{d.secondary_actors} \\\\"
      end    
      f << "
          \\textbf{Scopo e Descrizione} & #{d.description} \\\\ 
          
          \\textbf{Precondizioni}  & #{d.precondition}\\\\ 
          
          \\textbf{Postcondizioni} & #{d.postcondition} \\\\"
      if !d.main_flow.blank?    
      f << "
          \\textbf{Flusso Principale} & #{d.main_flow} \\\\
          "
      end
      if !d.alternative_flow.blank?    
        f << " \\textbf{Scenari Alternativi} & #{d.alternative_flow} \\\\" 
      end
      if !d.inclusion.blank?   
        f << " \\textbf{Inclusioni} & #{d.inclusion} \\\\" 
      end
      if !d.extension.blank?  
        f << " \\textbf{Esclusioni} & #{d.extension} \\\\" 
      end
      f << "
      \\end{longtable}
      \\egroup
\\end{center}
" 
end
      }
    send_file(file)
  end #end export

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_use_case
      @use_case = UseCase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def use_case_params
      params.require(:use_case).permit(:system, :hierarchy, :subtitle, :title, :primary_actors, :secondary_actors, :description, :precondition, :postcondition, :main_flow, :alternative_flow, :inclusion, :extension, :graph, :ancestry)
    end

    def get_ordered_data 
      @UCU = UseCase.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
      @UCS = UseCase.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
      @UCM = UseCase.where({system: "M"}).sort!{ |a,b| confronta(a,b) } 
    end
end
