class FamilyName < ActiveRecord::Migration
  def change
    remove_column :task_board, :name
    add_column :task_board, :family_id, :integer
    add_index :task_board, :family_id
  end
end
