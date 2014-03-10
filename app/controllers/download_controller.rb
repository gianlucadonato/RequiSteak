class DownloadController < ApplicationController
	before_filter :authenticate_user!

	def index
	end

#============= EXPORT COMPONENTS DEFINITION =============#
	def export_backend_definition()
		return export_definition("Back-end", "backend-definition.tex")
	end

	def export_frontend_definition()
		return export_definition("Front-end", "frontend-definition.tex")
	end

	def export_definition(main_component_title, file)
		File.open(file, "wb+"){ |f|

		 	components = []
			
			main_comp = Component.find_by_title(main_component_title);
			if !main_comp.nil?
				components << main_comp
				main_comp.descendants.each do |c|
					components << c
				end
			end

components.each do |comp|      
	f << "
	\\subsubsection{#{comp.full_title}} "

	if !comp.units.empty? 
		f<< "
		\\paragraph{Classi}"
		comp.units.each do |u| 
			f << "
			\\subparagraph{#{u.title}} "
			
			# Diagramma
			f << "
\\begin{table}[ht]
\\begin{center}
\\bgroup
	\\setlength{\\arrayrulewidth}{0.6mm}
	\\def\\arraystretch{1}
		\\begin{tabular}{ | p{12cm} | }
				\\hline  
					\\centerline{\\textbf{#{u.title}}}
		\\\\ \\hline "
			
			u.data_fields.each do |datafield|
				f << "
					\\code{#{datafield.format_name}} \\\\ "
			end

			f << "
				\\hline"
			
			u.unit_methods.each do |method|
				f << "
					\\code{#{method.format_name}} \\\\ "
			end

			f << "
				\\hline
		
		\\end{tabular}
\\egroup
\\caption{Classe #{u.title}}
\\end{center}
\\end{table} "

			# Descrizione

			f << " \\textbf{\\\\ \\\\ Descrizione} 
					\\begin{itemize}
						\\item[] #{u.description}
					\\end{itemize}      
				\\textbf{Utilizzo}  
					\\begin{itemize}
						\\item[] #{u.use}
					\\end{itemize}" 
				if !u.ancestors.empty?
				f << "
					\\textbf{Classi Estese}
					\\begin{itemize}"
						u.ancestors.each do |p|
							f << "
								\\item{#{p.full_title}}"
						end
				f << "
					\\end{itemize}"
				end
				if !u.descendants.empty?  
				f << "
					\\textbf{Estensioni}
					\\begin{itemize}"
						u.descendants.each do |c|
							f << "
							\\item{#{c.full_title}}"
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
							\\item{#{c.full_title}}"
						end
				f << "
					\\end{itemize}"
				end

			 # Descrizione metodi e attributi

			 f << "
			 \\textbf{Attributi} 
	\\begin{itemize}"
			
			u.data_fields.each do |datafield|
				f << "
					\\item[] \\textbf{\\code{#{datafield.format_name}}} \\\\ #{datafield.description}"
			end

			f << "
		\\end{itemize}
		
		\\textbf{Metodi} 
	\\begin{itemize}"
			
			u.unit_methods.each do |method|
				f << "
					\\item[] \\textbf{\\code{#{method.format_name}}} \\\\ #{method.description}
						\\begin{itemize}\\addtolength{\\itemsep}{-0.5\\baselineskip}
						\\item[] \\textbf{Parametri:}"
			
				method.parameters.each do |parameter|
					f << "
						\\item[] \\code{#{parameter.title}} \\\\ #{parameter.description}	"
				end
				f << "
				\\end{itemize}"
			end

			f << "
		\\end{itemize}"

		end
	end
end #end back_comp.each
		}
		send_file(file)
	end #end export_backend


#============= EXPORT COMPONENTS =============#
	def export_backend()
		return export_classes("Back-end", "backend-packages.tex")
	end

	def export_frontend()
		return export_classes("Front-end", "frontend-packages.tex")
	end
	
	def export_classes(main_component_title, file)
		File.open(file, "wb+"){ |f|

		 	components = []
			
			main_comp = Component.find_by_title(main_component_title);
			if !main_comp.nil?
				components << main_comp
				main_comp.descendants.each do |c|
					components << c
				end
			end

components.each do |comp|      
	f << "
	\\subsubsection{#{comp.full_title}}
	\\paragraph{Informazioni sul package} "
if !comp.graph.nil?
f << "
		\\begin{figure}[H] 
			\\begin{center} 
				\\includegraphics[width=\\textwidth]{uml/package/#{comp.full_title}.png}  
				\\caption{Componente #{comp.title}}
			\\end{center}  
		\\end{figure} "
end
f << "
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
				\\item #{pkg.full_title}" 
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
								\\item{#{p.full_title}}"
						end
				f << "
					\\end{itemize}"
				end
				if !u.descendants.empty?  
				f << "
					\\textbf{Estensioni}
					\\begin{itemize}"
						u.descendants.each do |c|
							f << "
							\\item{#{c.full_title}}"
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
							\\item{#{c.full_title}}"
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
			\\caption{Requisiti funzionali}
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
			\\caption{Requisiti di qualità}
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
			\\caption{Requisiti di vincolo}
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
			\\caption{Tracciamento requisiti-fonti}    
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
			\\caption{Tracciamento fonti-requisiti}   
			\\end{longtable}
			\\egroup
			\\end{center}  
\\clearpage"


f << "
\\subsection{Tracciamento Requisiti - Test di Sistema e Validazione}

	\\begin{center}
	\\def\\arraystretch{1.5}
	\\bgroup
		\\begin{longtable}{| p{2cm} | p{6cm} | p{2.5cm} | p{2.5cm} | }
		\\hline 
		 \\textbf{Requisito} & \\textbf{Descrizione} & \\textbf{Test di Sistema} & \\textbf{Test di Validazione} \\\\ \\hline"   
			
			@funzionali.each do |req|
			f << "
				#{req.title} & 
				#{req.description} & "
				if !req.system_test.nil?
					f << "#{req.system_test.title} &"
				else
					f << " & "
				end
				if !req.validation_test.nil?
					f << "#{req.validation_test.title}"
				end
				f << " \\\\ \\hline "
			end
f << "
		\\caption{Tracciamento Requisiti - Test di Sistema e Validazione}
		\\end{longtable}
	 \\egroup
\\end{center}
\\clearpage
"
			}
		send_file(file)
	end #end export_requirements

	def export_ts_req
		system_test = SystemTest.all.sort!{ |a,b| confronta_test(a,b) }
		file = "capitolo-test-di-sistema-requisiti.tex"
		File.open(file, "wb+"){ |f| 
	
f << "

	\\begin{center}
	\\def\\arraystretch{1.5}
	\\bgroup
		\\begin{longtable}{| p{3cm} | p{6cm} | p{1.5cm} | p{2cm} | }
		\\hline 
		 \\textbf{Test Sistema} & \\textbf{Descrizione} & \\textbf{Stato} & \\textbf{Requisito} \\\\ \\hline"   
			
			system_test.each do |st|
			f << "
				#{st.title} & 
				#{st.description} & "
				if st.status == false
					f << "N.E &"  
				else
					f << "Approved &"
				end
				if !st.requirements.empty?
					st.requirements.each do |r|
					f << "       
						#{r.title} \\newline " 
					end
				end
			f << " \\\\ \\hline "
			end
f << "
		\\caption{Tracciamento Test di Sistema - Requisiti}
		\\end{longtable}
	 \\egroup
\\end{center}"

		}
		send_file(file)
	end #end export_ts_req

	def export_tv_req
		validation_test = ValidationTest.all.sort!{ |a,b| confronta_test(a,b) }
		file = "capitolo-test-di-validazione-requisiti.tex"
		File.open(file, "wb+"){ |f| 

f << "
	\\begin{center}
	\\def\\arraystretch{1.5}
	\\bgroup
		\\begin{longtable}{| p{3cm} | p{6cm} | p{1.5cm} | p{2cm} | }
		\\hline 
		 \\textbf{Test di Validazione} & \\textbf{Descrizione} & \\textbf{Stato} & \\textbf{Requisito} \\\\ \\hline"   
			
			validation_test.each do |vt|
			f << "
				#{vt.title} & 
				#{vt.description} & " 
				if vt.status == false
					f << "N.E &"
				else
					f << "Approved &"
				end
				if !vt.requirements.empty?
					vt.requirements.each do |r|
					f << "       
						#{r.title} \\newline " 
					end
				end
			f << " \\\\ \\hline "
			end
f << "
		\\caption{Tracciamento Test di Validazione - Requisiti}
		\\end{longtable}
	 \\egroup
\\end{center}"

		}
		send_file(file)
	end #end export_ts_req
end

