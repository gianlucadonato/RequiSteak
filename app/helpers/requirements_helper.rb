module RequirementsHelper
	def nested_requirements(req)
		req.map do |requirement, sub_req|
			render(requirement) + content_tag(:div, nested_requirements(sub_req), :class => "nested_requirements")
		end.join.html_safe
	end
end
