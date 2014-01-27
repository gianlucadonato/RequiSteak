class UseCase < ActiveRecord::Base
	has_ancestry :cache_depth => true

	validates :system, presence: true
	validates :hierarchy, presence: true
end
