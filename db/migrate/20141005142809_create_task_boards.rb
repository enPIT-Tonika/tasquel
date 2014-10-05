class CreateTaskBoards < ActiveRecord::Migration
  def change
    create_table :task_boards do |t|
      t.text :taskText

      t.timestamps
    end
  end
end
