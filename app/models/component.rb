class Component < ActiveRecord::Base
	has_ancestry
	has_many :units
	belongs_to :integration_test
	has_many :packages, class_name: "Component", foreign_key: "package_id"
	belongs_to :package, class_name: "Component"

	validates :title, presence: true

	def full_title
		full_name = "";
		ancestors.each do |parent|
			full_name += parent.title + "::"
		end
		full_name += title
		return full_name
	end
end