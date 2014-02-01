class Component < ActiveRecord::Base
	has_ancestry
	has_many :packages, class_name: "Component", foreign_key: "package_id"
	belongs_to :package, class_name: "Component"

	validates :title, presence: true

	def get_name
		a = title.split('::') 
    b = a.count
    return a[b-1]
	end
end
