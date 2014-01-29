class Requirement < ActiveRecord::Base
	has_ancestry
	has_and_belongs_to_many :use_cases
	has_and_belongs_to_many :sources
	belongs_to :system_test
	belongs_to :validation_test
	
	validates :typology, presence: true
	validates :priority, presence: true
	validates :hierarchy, presence: true
end
