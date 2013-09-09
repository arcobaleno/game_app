class Credit < ActiveRecord::Base
	scope :all_pool_credits, where(:user_id => nil)

	attr_accessible :credit_id, :user_id, :pool_id, :credit_code, :value, :created_at, :updated_at
	belongs_to :user
	belongs_to :pool
	#belongs_to :pool

	validates :credit_code, presence: true, length: {minimum: 5, maximum: 5}
	
	def random #Generates Random Credit Code
		self.credit_code = (0..4).map{ rand(36).to_s(36) }.join
	end

	# Search Bar

	def self.search(search)
		if search
			where('credit_code LIKE ?', "%#{search}%")
		else
			scoped
		end
	end

	#Credits associated with a Particular Group: bank, vendors, users, pool etc..

  	def self.all_credits_in(group)
  		find_all_by_user_id(group)
  	end

  	#Credits associated with one user or pool
	def self.player_credits(current_user) #NOTE please convert to scope later on!
		find(:all, :conditions => {:user_id => current_user.id, :pool_id => nil})
	end

	def self.pool_credits(current_user) #NOTE please convert to scope later on!
		current_user.players.sum(:bet)
	end

	#What happens when a banker transfers credits to a vendor
	def self.transfer_credits_banker_to_vendor(vendor, banker, amount)
		$i = 0
		$num = amount.to_i
		while $i < $num do
			@credit = find_all_by_user_id(banker).first
			@credit.user_id = vendor.id
			@credit.save
			$i +=1
		end
	end

	#What happens when a user redeems a credit from a vendor
	def self.transfer_vendor_credits_to_user(credit, current_user)
		@credit = credit.first
		@credit.user_id = current_user.id
		@credit.save
	end

	#What happens when a user joins a pool
	def self.transfer_user_credits_to_pool(current_user, pool, buy_in) #NOTE will change for multiple credit transfer
		$i = 0
		$num = buy_in
		while $i < $num do
			@credit = find_all_by_user_id(current_user).first
			@credit.user_id = nil
			@credit.pool_id = pool.id
			@credit.save
			$i +=1
		end
	end

	#What happens when a user gets paid out from winning
	def self.transfer_pool_credits_to_user(pool, player)
		@credit = find_all_by_pool_id(pool).first
		@credit.user_id = player.user_id
		@credit.pool_id = nil
		@credit.save
	end

	#What happens when a user redeems a prize for credits
	def self.transfer_user_credits_to_banker(user, prize_value)
		$i = 0
		$num = prize_value
		while $i < $num do
			@credits = Credit.find_all_by_user_id(user)
			@credit = @credits.first #NOTE change so it works with transfer of multiple credits
			@credit.user_id = User.bankers.first.id
			@credit.save
			$i +=1
		end
		return true
	end

	#What happens when a user gets destroyed/deleted

	def self.transfer_user_credits_upon_destroy(user,banker)
		find_all_by_user_id(user).each do |credit|
			credit.user_id = banker.id
			credit.save
		end
		# MUST DESTROY ALL ASSOCIATED PLAYERS AS WELL
	end
	
end