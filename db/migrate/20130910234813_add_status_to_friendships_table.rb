class AddStatusToFriendshipsTable < ActiveRecord::Migration
  def change
  	add_column :friendships, :status, :string
  	add_column :friendships, :accepted_at, :datetime
  end
end
