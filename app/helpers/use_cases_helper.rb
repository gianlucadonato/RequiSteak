module UseCasesHelper
	def nested_usecases(uc)
		uc.map do |use_case, sub_uc|
			content_tag(:div,
				content_tag(:div,
					link_to(@prefix + use_case.hierarchy, use_case_path(use_case), class: "orange treelabel") + 
						content_tag(:label, 
							content_tag(:strong, "\  " + use_case.title.split(" ")[2..-1].join(" ")),
						class: "nested_label") +
					content_tag(:p, use_case.description, class: "nested_p")),
				class: "use_case panel") +
	    
			content_tag(:div, nested_usecases(sub_uc), :class => "nested_requirements")
		end.join.html_safe
	end
end
