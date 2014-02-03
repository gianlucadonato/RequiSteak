class IntegrationTest < ActiveRecord::Base
	has_many :components
	validates :title, presence: true
end
