class Unit < ActiveRecord::Base
	has_ancestry
	
	belongs_to :component
	belongs_to :unit, class_name: "Unit"
	has_many :units, class_name: "Unit", foreign_key: "class_id"
	has_many :data_fields

	validates :title, presence: true

	def get_name
		a = title.split('::') 
    b = a.count
    return a[b-1]
	end
end
