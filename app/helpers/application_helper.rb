module ApplicationHelper
	def find_thumbnail_url hash
		hash.map{|k,v|v}.join('.')
	end
end
