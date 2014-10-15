class FamilyName < ActiveRecord::Migration
  def change
    remove_column :task_boards, :name_id
    add_column :task_boards, :family_id, :integer
    add_index :task_boards, :family_id
  end
end
