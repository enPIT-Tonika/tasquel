class CreateDoneLists < ActiveRecord::Migration
  def change
    create_table :done_lists do |t|
      t.references :user, index: true
      t.integer :tweet_id
      t.text :desc
      t.boolean :is_reply
      t.datetime :reply_time

      t.timestamps
    end
  end
end
