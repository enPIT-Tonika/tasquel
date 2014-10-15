class AddNameToTaskBoard < ActiveRecord::Migration
  def change
    add_reference :task_boards, :name, index: true
  end
end
