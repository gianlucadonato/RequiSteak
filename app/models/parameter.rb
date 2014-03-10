class Parameter < ActiveRecord::Base
	belongs_to :unit_method

	def format_name
		return self.name + ":" + self.parameter_type
	end
end
