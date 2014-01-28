module RequirementsHelper
	def nested_requirements(req)
		req.map do |requirement, sub_req|
			content_tag(:div,	
				content_tag(:div,
					content_tag(:dl, 
						content_tag(:dd, content_tag(:a, requirement.title, href: "#panel#{requirement.id}", class: "green"), class: "active") +
						
						if !requirement.use_cases.empty? 
							content_tag(:dd, content_tag(:a, "UC", href: "#panel#{requirement.id}#{requirement.system}", class: "orange")) 
						end +
						
						content_tag(:dd, content_tag(:a, "TS1", href: "#panel3", class: "purple")) +
						content_tag(:dd, content_tag(:a, "TS1", href: "#panel4", class: "water")),
					class: "tabs", data: { tab: "" }) +
					content_tag(:div, 
						content_tag(:div, content_tag(:p, content_tag(:a, capture do link_to requirement.title, requirement_path(requirement) end) + ": " + requirement.description),class: "content active", id: "panel#{requirement.id}") +
						
						if !requirement.use_cases.empty? 
							content_tag(:div, content_tag(:p), class: "content", id: "panel#{requirement.id}#{requirement.system}") 
						end +
						
						content_tag(:div, content_tag(:p, "hello"),class: "content", id: "panel3") +
						content_tag(:div, content_tag(:p, "world"),class: "content", id: "panel4"),
					class: "tabs-content"),
				class: "requirement"),
			class: "panel") +

	    
			content_tag(:div, nested_requirements(sub_req), :class => "nested_requirements")
		end.join.html_safe
	end
end

