module ApplicationHelper
	#Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = 'JI'
		if page_title.empty?
			base_title
		else
			"#{base_title} |  #{page_title}"
		end
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title, params.merge(:sort => column, :direction => direction, :page => nil)
	end
end
