class ChangeTimeForGamesTable < ActiveRecord::Migration
  def change
  	add_column :games, :date_time, :datetime
  	remove_column :games, :date
  	remove_column :games, :time
  end
end
