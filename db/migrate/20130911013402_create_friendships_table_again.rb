class CreateFriendshipsTableAgain < ActiveRecord::Migration
  def change
  	create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "accepted_at"
  	end
  end
end
