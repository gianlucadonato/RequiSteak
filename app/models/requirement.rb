class Requirement < ActiveRecord::Base
	has_ancestry
	has_and_belongs_to_many :use_cases
	
	validates :typology, presence: true
	validates :priority, presence: true
	validates :hierarchy, presence: true
end
