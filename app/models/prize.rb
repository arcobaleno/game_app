class Prize < ActiveRecord::Base
	attr_accessible :user_id, :value, :prize_type, :description, :redeemed, :mailed
	belongs_to :user

	validates :value, presence: true
	validates :prize_type, presence: true
	validates :description, presence: true
	validates :redeemed, presence: true, length: {minimum: 1, maximum: 1}
	validates :mailed, presence: true, length: {minimum: 1, maximum: 1}
	
end