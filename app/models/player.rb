class Player < ActiveRecord::Base
	attr_accessible :user_id, :pool_id, :team_one_predicted_score, :team_two_predicted_score, :winner, :bet
	belongs_to :pool
	belongs_to :game
	belongs_to :user

	validates :team_one_predicted_score, presence: true
	validates :team_two_predicted_score, presence: true

end