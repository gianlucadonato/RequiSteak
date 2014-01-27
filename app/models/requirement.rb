class Requirement < ActiveRecord::Base
	has_ancestry

	validates :typology, presence: true
	validates :priority, presence: true
	validates :hierarchy, presence: true
end
