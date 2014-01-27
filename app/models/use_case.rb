class UseCase < ActiveRecord::Base
	has_ancestry

	validates :system, presence: true
	validates :hierarchy, presence: true
end
