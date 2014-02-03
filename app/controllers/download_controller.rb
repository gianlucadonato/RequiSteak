class DownloadController < ApplicationController
	before_filter :authenticate_user!

	def index
	end

#============= EXPORT BACK-END COMPONENTS =============#
	def export_backend
file = "backend-packages.tex"
    File.open(file, "wb+"){ |f|
      f << "\\subsection{Packages}"
     	back_comp = []
      backend = Component.find_by_title("Back-end");
      if !backend.nil?
        back_comp << backend
        backend.descendants.each do |c|
          back_comp << c
        end
      end
back_comp.each do |comp|      
  f << "
  \\subsubsection{#{comp.title}}
  \\paragraph{Informazioni sul package} 

    \\begin{figure}[H] 
      \\begin{center} 
        %\\includegraphics[scale=1]{packages/NomePackage.png}  
        \\caption{Componente #{comp.title}}
      \\end{center}  
    \\end{figure} 

  \\subparagraph{Descrizione} 
    \\begin{itemize}
    \\item[] #{comp.description}
    \\end{itemize} "

  if !comp.children.empty?
  f << "
    \\subparagraph{Package contenuti} 
    \\begin{itemize}"
    comp.children.each do |pkg|  
      f << "
        \\item #{pkg.title}" 
    end
  f << "
    \\end{itemize}"
  end

  if !comp.packages.empty?  
  f<< "
  \\subparagraph{Interazioni con altri componenti} 
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
    \\paragraph{Classi}"
    comp.units.each do |u| 
      f << "
      \\subparagraph{#{u.title}}
        
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
end #end back_comp.each
    }
    send_file(file)
	end #end export_backend


#============= EXPORT FRONT-END COMPONENTS =============#
	def export_frontend
file = "frontend-packages.tex"
    File.open(file, "wb+"){ |f|
      f << "\\subsection{Packages}"
     	front_comp = []
      frontend = Component.find_by_title("Front-end");
      if !frontend.nil?
        front_comp << frontend
        frontend.descendants.each do |c|
          front_comp << c
        end
      end
front_comp.each do |comp|      
  f << "
  \\subsubsection{#{comp.title}}
  \\paragraph{Informazioni sul package} 

    \\begin{figure}[H] 
      \\begin{center} 
        %\\includegraphics[scale=1]{packages/NomePackage.png}  
        \\caption{Componente #{comp.title}}
      \\end{center}  
    \\end{figure} 

  \\subparagraph{Descrizione} 
    \\begin{itemize}
    \\item[] #{comp.description}
    \\end{itemize} "

  if !comp.children.empty?
  f << "
    \\subparagraph{Package contenuti} 
    \\begin{itemize}"
    comp.children.each do |pkg|  
      f << "
        \\item #{pkg.title}" 
    end
  f << "
    \\end{itemize}"
  end

  if !comp.packages.empty?  
  f<< "
  \\subparagraph{Interazioni con altri componenti} 
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
    \\paragraph{Classi}"
    comp.units.each do |u| 
      f << "
      \\subparagraph{#{u.title}}
        
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
end #end front_comp.each
    }
    send_file(file)
	end #end export_frontend


#============= EXPORT USE CASES =============#
  def export_use_cases
    @UCU = UseCase.where({system: "U"}).sort!{ |a,b| confronta(a,b) }
    @UCS = UseCase.where({system: "S"}).sort!{ |a,b| confronta(a,b) }
    @UCM = UseCase.where({system: "M"}).sort!{ |a,b| confronta(a,b) }  

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
      }
    send_file(file)    
  end #end export_use_cases


#============= EXPORT REQUIREMENTS =============#
  def export_requirements
    @funzionali = Requirement.where({typology: "1"}).sort!{ |a,b| confronta(a,b) }
    @qualita = Requirement.where({typology: "3"}).sort!{ |a,b| confronta(a,b) }
    @vincolo = Requirement.where({typology: "4"}).sort!{ |a,b| confronta(a,b) }
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
  end #end export_requirements
end
