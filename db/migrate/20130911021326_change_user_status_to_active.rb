class ChangeUserStatusToActive < ActiveRecord::Migration
  def change
  	remove_column :users, :status
  	add_column :users, :active, :boolean, :default => true
  end
end
