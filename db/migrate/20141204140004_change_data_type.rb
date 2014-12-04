class ChangeDataType < ActiveRecord::Migration
  def change
	change_column :done_lists, :tweet_id, :text
  end
end
