class UseCase < ActiveRecord::Base
	has_ancestry
	has_and_belongs_to_many :requirements

	validates :system, presence: true
	validates :hierarchy, presence: true
end
