class CreateTaskBoards < ActiveRecord::Migration
  def change
    create_table :task_boards do |t|
      t.text :taskText

      t.timestamps
    end
    
    change_table :task_boards do |t|
      t.text :taskText
      t.references :name
      t.timestamps
    end
    
    change_table :task_boards do |t|
      t.time :time
      t.text :taskText
      t.references :name
      t.timestamps
    end
  end
end
