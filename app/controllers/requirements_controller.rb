class RequirementsController < ApplicationController
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]
  before_action :get_ordered_data , only: [:index, :show, :export]
  
  # GET /requirements
  def index
  end

  # GET /requirements/1
  def show
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
    if !@requirement.system.nil? 
      @prefix = "R" + @requirement.system + @requirement.typology + @requirement.priority
    else
      @prefix = "R" + @requirement.typology + @requirement.priority
    end
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
      @requirement.source_ids = params[:requirement][:source_ids] unless params[:requirement][:source_ids].blank?
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

  def export
    uc = UseCase.where.not(title: ['UCU 0 - Operazioni ad alto livello - Utente autenticato', 
                                   'UCU 0 - Operazioni ad alto livello - Utente non autenticato', 
                                   'UCM 0 - Operazioni ad alto livello - Utente MaaS autenticato',
                                   'UCM 0 - Operazioni ad alto livello - Utente MaaS non autenticato',
                                   'UCS 0 - Operazioni ad alto livello'])
    ucu = uc.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
    ucs = uc.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
    ucm = uc.where({system: "M"}).sort!{ |a,b| confronta(a,b) }

    file = "capitolo-requisiti.tex"
    File.open(file, "wb+"){ |f| 

#==== FUNZIONALI ====#
f << "\\section{Requisiti }
I requisiti funzionali, prestazionali, di qualità e di vincolo individuati sono riportati nelle seguenti tabelle. Ogni requisito è identificato da un codice univoco.
Viene inoltre indicato se si tratta di un requisito fondamentale, desiderabile o facoltativo, una sua descrizione e il caso d'uso da cui è stato individuato. 

Ogni requisito è identificato da un codice, che segue il seguente formalismo:
\\begin{center}
    \\code{R\\{X\\}\\{Y\\}\\{Z\\} \\{Gerarchia\\}}
\\end{center}

Dove:
\\begin{itemize}
 \\item \\textbf{X} corrisponde al sistema di riferimento e può assumere i seguenti valori:
    \\begin{itemize}
     \\item[] \\textbf{A} = Applicazione \\glossario{Maap};
     \\item[] \\textbf{F} = \\glossario{Framework MaaP};
     \\item[] \\textbf{S} = \\glossario{MaaS}.
    \\end{itemize}

 \\item \\textbf{Y} corrisponde alla tipologia del requisito e può assumere i seguenti valori:
    \\begin{itemize}
     \\item[] \\textbf{1} = Funzionale;
     \\item[] \\textbf{2} = Prestazionale;
     \\item[] \\textbf{3} = Di Qualità;
     \\item[] \\textbf{4} = Vincolo.
    \\end{itemize}

 \\item \\textbf{Z} corrisponde alla priorità del requisito e può assumere i seguenti valori:
    \\begin{itemize}
     \\item[] \\textbf{O} = Obbligatorio
     \\item[] \\textbf{D} = Desiderabile
     \\item[] \\textbf{F} = Facoltativo o Opzionale
    \\end{itemize}

 \\item \\textbf{Gerarchia} identifica la relazione gerarchica che c'è tra i requisiti di uno stesso tipo. C'è quindi una struttura gerarchica per ogni tipologia di requisito.
\\end{itemize}

\\subsection{Requisiti funzionali }

    %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}
      \\begin{longtable}{ | l | p{2cm} | p{5cm} | p{1.7cm} |}
    
      \\cellcolor[gray]{0.9} \\textbf{Requisito} & \\cellcolor[gray]{0.9} \\textbf{Tipologia} 
      & \\cellcolor[gray]{0.9} \\textbf{Descrizione} & \\cellcolor[gray]{0.9} \\textbf{Fonti} \\\\ \\hline
"

@funzionali.each do |d|
f << "      
        #{d.title} & Funzionale \\newline "

    if d.priority == "O"
        f << " Obbligatorio " 
    elsif d.priority == "D"
        f << " Desiderabile " 
    else d.priority == "F"
        f << " Facoltativo " 
    end

    f << " & #{d.description} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " + uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end

    f << "
      \\end{longtable}
      \\egroup
      \\end{center}  
\\clearpage
"

#==== DI QUALITA' ====#
f << "
\\subsection{Requisiti di qualità }

    %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}
      \\begin{longtable}{ | l | p{2cm} | p{5cm} | p{1.7cm} |}
    
      \\cellcolor[gray]{0.9} \\textbf{Requisito} & \\cellcolor[gray]{0.9} \\textbf{Tipologia} 
      & \\cellcolor[gray]{0.9} \\textbf{Descrizione} & \\cellcolor[gray]{0.9} \\textbf{Fonti} \\\\ \\hline
"
@qualita.each do |d|
f << "      
        #{d.title} & Qualità \\newline "

    if d.priority == "O"
        f << " Obbligatorio " 
    elsif d.priority == "D"
        f << " Desiderabile " 
    else d.priority == "F"
        f << " Facoltativo " 
    end

    f << " & #{d.description} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " +  uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end

    f << "
      \\end{longtable}
      \\egroup
      \\end{center}  
\\clearpage
"

#==== VINCOLO ====#
f << "
\\subsection{Requisiti di vincolo }

    %Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}
      \\begin{longtable}{ | l | p{2cm} | p{5cm} | p{1.7cm} |}
    
      \\cellcolor[gray]{0.9} \\textbf{Requisito} & \\cellcolor[gray]{0.9} \\textbf{Tipologia} 
      & \\cellcolor[gray]{0.9} \\textbf{Descrizione} & \\cellcolor[gray]{0.9} \\textbf{Fonti} \\\\ \\hline
"
@vincolo.each do |d|
f << "      
        #{d.title} & Vincolo \\newline "

    if d.priority == "O"
        f << " Obbligatorio " 
    elsif d.priority == "D"
        f << " Desiderabile " 
    else d.priority == "F"
        f << " Facoltativo " 
    end

    f << " & #{d.description} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " +  uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end

    f << "
      \\end{longtable}
      \\egroup
      \\end{center}  
\\clearpage"


#==== TRACCIAMENTO REQUISITI ====#
f << "
\\section{Tracciamento Requisiti}
\\subsection{Tracciamento requisiti-fonti}
%Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}
      \\begin{longtable}{ | p{5cm} | p{5cm} |}
    
      \\cellcolor[gray]{0.9} \\textbf{Requisiti} & \\cellcolor[gray]{0.9} \\textbf{Fonti} \\\\ \\hline "

@funzionali.each do |d|
f << "      
        #{d.title} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " + uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end
@qualita.each do |d|
f << "      
        #{d.title} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " + uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end
@vincolo.each do |d|
f << "      
        #{d.title} & "
    
    uc = d.use_cases
    src = d.sources

    src.each do |src|
      f << " #{src.title} \\newline "
    end
    uc.each do |u|
      uc_t = u.title.split(' ')
      uc_title = uc_t[0] + "\ " + uc_t[1]
      f << " #{uc_title} \\newline "
    end
    f << " \\\\ \\hline"    
end

    f << "     
      \\end{longtable}
      \\egroup
      \\end{center}  
\\clearpage

\\subsection{Tracciamento fonti-requisiti}
%Tabella 
      \\begin{center}
      \\bgroup
      \\def\\arraystretch{1.8}
      \\begin{longtable}{ | p{5cm} | p{5cm} |}
    
      \\cellcolor[gray]{0.9} \\textbf{Fonti} & \\cellcolor[gray]{0.9} \\textbf{Requisiti} \\\\ \\hline "
      
      ucu.each do |uc|
        f << "      
            #{uc.title} & "
        
        req = uc.requirements
        req.each do |r|
          
          f << " #{r.title} \\newline "
        end
        f << " \\\\ \\hline"  
      end
      ucs.each do |uc|
        f << "      
            #{uc.title} & "
        
        req = uc.requirements
        req.each do |r|
          
          f << " #{r.title} \\newline "
        end
        f << " \\\\ \\hline"  
      end
      ucm.each do |uc|
        f << "      
            #{uc.title} & "
        
        req = uc.requirements
        req.each do |r|
          
          f << " #{r.title} \\newline "
        end
        f << " \\\\ \\hline"  
      end

      f << "     
      \\end{longtable}
      \\egroup
      \\end{center}  
\\clearpage

"
      }
    send_file(file)
  end #end export

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def requirement_params
    params.require(:requirement).permit(:system, :typology, :priority, :hierarchy, :title, :status, :description, :ancestry, :use_case_ids)
  end

  def get_ordered_data 
    @funzionali = Requirement.where({typology: "1"}).sort!{ |a,b| confronta(a,b) }
    @qualita = Requirement.where({typology: "3"}).sort!{ |a,b| confronta(a,b) }
    @vincolo = Requirement.where({typology: "4"}).sort!{ |a,b| confronta(a,b) }

    @UCU = UseCase.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
    @UCS = UseCase.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
    @UCM = UseCase.where({system: "M"}).sort!{ |a,b| confronta(a,b) }

    @sources = Source.all
  end
end
