class Credit < ActiveRecord::Base
	attr_accessible :credit_id, :user_id, :pool_id, :credit_code, :value, :created_at, :updated_at
	belongs_to :user
	#belongs_to :pool

	validates :credit_code, presence: true, length: {minimum: 5, maximum: 5}
	
	def self.search(search)
		if search
			where('credit_code LIKE ?', "%#{search}%")
		else
			scoped
		end
	end

	def self.player_credits(current_user)
		find(:all, :conditions => {:user_id => current_user.id, :pool_id => nil}).count
	end

	def self.pool_credits(current_user)
		current_user.players.sum(:bet)
	end

	def self.transfer_user_credits_upon_destroy(user,banker)
		find_all_by_user_id(user).each do |credit|
			credit.user_id = banker.id
			credit.save
		end
		# MUST DESTROY ALL ASSOCIATED PLAYERS AS WELL
	end

end