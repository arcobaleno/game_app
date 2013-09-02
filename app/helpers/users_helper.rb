module UsersHelper
	def full_name(user)
		user.first_name + " " + user.last_name
	end

	#Check Admin

	def admin?
		current_user.user_type == 4
	end

	def banker?
		current_user.user_type == 3
	end
end