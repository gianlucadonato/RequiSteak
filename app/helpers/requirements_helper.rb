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

						if !requirement.system_test_id.nil? 
							content_tag(:dd, content_tag(:a, "TS", href: "#", class: "purple")) 
						end +

						if !requirement.validation_test_id.nil? 
							content_tag(:dd, content_tag(:a, "TV", href: "#", class: "water"))
						end,
					class: "tabs", data: { tab: "" }) +
					content_tag(:div, 
						content_tag(:div, content_tag(:p, 
							content_tag(:a, 
								capture do 
									link_to requirement.title, requirement_path(requirement) 
								end) + ": " + requirement.description),
						class: "content active", id: "panel#{requirement.id}"),
					class: "tabs-content"),
				class: "requirement"),
			class: "panel") +

	    
			content_tag(:div, nested_requirements(sub_req), :class => "nested_requirements")
		end.join.html_safe
	end
end

