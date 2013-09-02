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

	def check_credits?
		@credits = Credit.find_all_by_user_id(current_user)
		@credits.count > 0
	end
end