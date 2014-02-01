class Unit < ActiveRecord::Base
	has_ancestry
	belongs_to :component
	has_many :units, class_name: "Unit", foreign_key: "class_id"
	belongs_to :unit, class_name: "Unit"
	
	validates :title, presence: true

	def get_name
		a = title.split('::') 
    b = a.count
    return a[b-1]
	end
end
