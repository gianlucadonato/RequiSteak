class DownloadController < ApplicationController
	before_filter :authenticate_user!

	def index
	end

	def export_backend
	end #end export_backend

	def export_frontend
	end #end export_frontend
end
