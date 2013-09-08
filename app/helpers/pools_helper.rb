module PoolsHelper

	def pool_type(pool)
		if pool.pool_type == "cs"
			return "Closest Score"
		elsif pool.pool_type == "ct"
			return "Choose Team"
		end
	end

	def pool_owner(user)
		@user = User.find_by_id(user)
		@user.first_name + " " + @user.last_name
	end

end