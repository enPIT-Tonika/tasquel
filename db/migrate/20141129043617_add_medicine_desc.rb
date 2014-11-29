class AddMedicineDesc < ActiveRecord::Migration
  def change
	add_column :users, :medicine_desc, :text
  end
end
