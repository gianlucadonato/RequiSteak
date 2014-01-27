module UseCasesHelper
	def nested_usecases(uc)
		uc.map do |usecase, sub_uc|
			content_tag(:div,
				content_tag(:dl, 
					content_tag(:dd, content_tag(:a, usecase.title, href: "#panel#{usecase.id}", class: "green"), class: "active") +
					content_tag(:dd, content_tag(:a, "Requiremnts", href: "#panel4", class: "water")),
				class: "tabs", data: { tab: "" }) +
				content_tag(:div, 
					content_tag(:div, content_tag(:p, content_tag(:a, capture do link_to usecase.title, requirement_path(usecase) end) + ": " + usecase.description),class: "content active", id: "panel#{usecase.id}") +
					content_tag(:div, content_tag(:p, "world"),class: "content", id: "panel4"),
				class: "tabs-content"),
			class: "usecase") +
	    
			content_tag(:div, nested_usecase(sub_uc), :class => "nested_requirements")
		end.join.html_safe
	end
end
