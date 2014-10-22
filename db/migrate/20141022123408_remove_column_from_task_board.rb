class RemoveColumnFromTaskBoard < ActiveRecord::Migration
  def change
	remove_column :task_boards, :time_id
	remove_column :task_boards, :time 
	add_column :task_boards, :time, :time
  end
end
