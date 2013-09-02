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

end