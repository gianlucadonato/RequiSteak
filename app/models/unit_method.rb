class UnitMethod < ActiveRecord::Base
	belongs_to :unit
	belongs_to :unit_test
	has_many :parameters
	
	def format_name
		format_title = ""

		if self.visibility == "public"
			format_title = "+"
		elsif self.visibility == "protected"
			format_title = "#"
		elsif self.visibility == "private"
			format_title = "-"
		else
			format_title = self.visibility
		end
		
		format_title += self.name + "("

		len = self.parameters.count
		self.parameters.sort!{ |a,b| a.weight.to_i <=> b.weight.to_i }.each_with_index do |p, index|
			if !((index + 1) == len) 
				format_title += p.format_name + ", "
			else
				format_title += p.format_name
			end
		end

		format_title += ")"		
		
		if return_type?
			format_title += ":" + self.return_type
		end

		return format_title
	end
end
