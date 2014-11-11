class AddRowOrderToTaskBoards < ActiveRecord::Migration
  def change
    add_column :task_boards, :row_order, :integer
  end
end
