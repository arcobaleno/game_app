module UsersHelper
	def full_name(user)
		user.first_name + " " + user.last_name
	end

	#Check Admin

	def admin?
		current_user.user_type == 4
	end

	def admin_delete?
		current_user.user_type == 4 && !current_user?(user)
	end

	def banker?
		current_user.user_type == 3
	end

	def check_credits?
		@credits = Credit.find_all_by_user_id(current_user)
		@credits.count > 0
	end

	def user_credits(user)
		@credits = Credit.find_all_by_user_id(user)
		@credits.count
	end

	def pool_credits(user)
    	@players = user.players
    	@pool_credits = @players.sum(:bet)
	end
end