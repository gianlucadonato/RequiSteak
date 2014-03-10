class DataField < ActiveRecord::Base
	belongs_to :unit

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
		
		format_title += " " + self.name
		
		if data_type?
			format_title += ":" + self.data_type
		end

		return format_title
	end
end
