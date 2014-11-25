class AddMedicineColumn < ActiveRecord::Migration
  def change
    add_column :users, :medicine_num, :integer
  end
end