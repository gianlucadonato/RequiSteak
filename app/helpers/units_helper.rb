module UnitsHelper
	def nested_units(unit)
		content_tag(:ul,
			unit.map do |unit, sub_unit|
				content_tag(:li, link_to(unit.title, unit_path(unit))) +
					if !sub_unit.empty?
						nested_units(sub_unit)
					end	
			end.join.html_safe
		)	
	end
end
