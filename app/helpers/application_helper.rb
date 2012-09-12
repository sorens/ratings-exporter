require 'csv'

module ApplicationHelper
	def csv_helper( titles )
		CSV.generate do |csv|
			titles.each do |title|
				csv << [title.netflix_id, title.name, title.year, title.url, title.rating, title.netflix_type, title.viewed_date, title.exported]
			end
		end
	end
end
