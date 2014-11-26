class AddJsonData < ActiveRecord::Migration
  def change
    add_column :users, :json_time, :json
  end
end
