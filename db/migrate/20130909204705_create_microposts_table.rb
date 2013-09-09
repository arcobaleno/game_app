class CreateMicropostsTable < ActiveRecord::Migration
  def change
	  	create_table "microposts", :force => true do |t|
	    t.integer  "user_id"
	    t.integer  "pool_id"
	    t.string   "content"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  	end
	end
end
