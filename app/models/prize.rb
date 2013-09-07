class Prize < ActiveRecord::Base
	scope :prizes_available, where(:redeemed => 0)
	scope :prizes_redeemed, where(:redeemed => 1)

	attr_accessible :user_id, :value, :prize_type, :description, :redeemed, :mailed
	belongs_to :user

	validates :value, presence: true
	validates :prize_type, presence: true
	validates :description, presence: true
	validates :redeemed, presence: true, length: {minimum: 1, maximum: 1}
	validates :mailed, presence: true, length: {minimum: 1, maximum: 1}
	
	#What happens when a prize is redeemed
	def self.redeem_prize_for(current_user, prize)
		prize.user_id = current_user.id
		prize.redeemed = 1
		prize.save
	end
end