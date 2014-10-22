class AddTasktimeToTaskboard < ActiveRecord::Migration
  def change
    add_column :taskboards, :tasktime, :time
  end
end
