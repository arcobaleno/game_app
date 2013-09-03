module PoolsHelper

	def pool_type(pool)
		if pool.pool_type == "cs"
			return "Closest Score"
		elsif pool.pool_type == "ct"
			return "Choose Team"
		end
	end
end