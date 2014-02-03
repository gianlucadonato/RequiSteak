class DownloadController < ApplicationController
	before_filter :authenticate_user!

	def index
	end

	def export_backend
file = "backend-packages.tex"
    File.open(file, "wb+"){ |f|
      f << "\\subsection{Packages}"
     	comp = []
      backend = Component.find_by_title("Back-end");
      if !backend.nil?
        comp << backend
        backend.descendants.each do |c|
          comp << c
        end
      end
comp.each do |comp|      
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

  if !comp.descendants.empty?
  f << "
    \\subparagraph{Package contenuti} 
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
end #end comp.each
    }
    send_file(file)
	end #end export_backend

	def export_frontend
	end #end export_frontend
end
