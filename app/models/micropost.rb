class Micropost < ActiveRecord::Base

	attr_accessible :user_id, :pool_id, :content
	belongs_to :user
	belongs_to :pool

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

	default_scope order: 'microposts.created_at DESC'

	def self.pool_microposts(pool)
		find_all_by_pool_id(pool)
	end
end