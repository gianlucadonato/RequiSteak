class ValidationTest < ActiveRecord::Base
	has_many :requirements
	validates :title, presence: true
end
