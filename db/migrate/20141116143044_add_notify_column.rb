class AddNotifyColumn < ActiveRecord::Migration
  def change
	add_column :users, :notify, :boolean, default: false
  end
end
