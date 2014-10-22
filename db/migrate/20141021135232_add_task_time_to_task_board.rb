class AddTaskTimeToTaskBoard < ActiveRecord::Migration
  def change
    add_column :task_boards, :time, :timestamp
  end
end
