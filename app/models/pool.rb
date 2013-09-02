class Pool < ActiveRecord::Base
	attr_accessible :game_id, :user_id, :pool_type, :status, :buy_in, :max_players

	has_many :credits
	has_many :players
	belongs_to :game
	belongs_to :user


end