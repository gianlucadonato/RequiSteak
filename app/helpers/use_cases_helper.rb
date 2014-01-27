module UseCasesHelper
	def nested_usecases(uc)
		uc.map do |use_case, sub_uc|
			content_tag(:div,
				content_tag(:dl, 
					content_tag(:dd, content_tag(:a, @prefix + use_case.hierarchy, href: "#panel#{use_case.id}", class: "orange"), class: "active") +
					content_tag(:dd, content_tag(:a, "Requirements", href: "#panel-req", class: "green")),
				class: "tabs", data: { tab: "" }) +
				content_tag(:div, 
					content_tag(:div, content_tag(:p, content_tag(:a, capture do link_to use_case.title, use_case_path(use_case) end) + 
						content_tag(:p, use_case.description, class: "nested_parag")),class: "content active", id: "panel#{use_case.id}") +
					content_tag(:div, content_tag(:p, "world"),class: "content", id: "panel-req"),
				class: "tabs-content"),
			class: "use_case") +
	    
			content_tag(:div, nested_usecases(sub_uc), :class => "nested_requirements")
		end.join.html_safe
	end
end
