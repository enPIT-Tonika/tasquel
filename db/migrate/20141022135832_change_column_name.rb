class ChangeColumnName < ActiveRecord::Migration
  def change
	rename_column :task_boards, :time, :tasktime
  end
end
