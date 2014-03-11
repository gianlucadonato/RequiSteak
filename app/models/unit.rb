class Unit < ActiveRecord::Base
	has_ancestry
	
	belongs_to :component
	belongs_to :unit, class_name: "Unit"
	has_many :units, class_name: "Unit", foreign_key: "class_id"
	
	has_many :data_fields
	has_many :unit_methods

	belongs_to :unit_test

	validates :title, presence: true

	def full_title
		full_name = "";
		if component
			full_name = component.full_title + "::"
		end
		ancestors.each do |parent|
			full_name += parent.title + "::"
		end
		full_name += title
		return full_name
	end

	def attention_level
		if missing == 0
			return ""
		elsif missing == unit_methods.length 
			return "alert"
		else
			return "warning"
		end
	end

	def missing
		miss = 0
		unit_methods.each do |m|
			if !m.unit_test
				miss += 1
			end
		end
		return miss
	end
end
