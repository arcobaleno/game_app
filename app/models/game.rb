class Game < ActiveRecord::Base
 attr_accessible :user_id, :sport, :team_one, :team_two, :team_one_score, :team_two_score, :winner, :date_time

 belongs_to :user
 has_many :users, :through => :pools
 has_many :pools

 default_scope order: 'games.created_at DESC'

 def event_time
 	date_time.to_time.strftime('%b %e, %Y - %l:%M %p')
 end

end