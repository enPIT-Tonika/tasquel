require 'test_helper'
require 'shoulda'

class TaskBoardTest < ActiveSupport::TestCase
#class TaskBoardTest < ActiveRecord::TestCase
#familyテーブルとの関連を確認
  should belong_to(:family)
  
# taskmemoが空の場合は投稿を許可しない
  test "The post should not accept when the taskText is null" do
    taskBoard = TaskBoard.new({
      taskText: '',
      family_id: 1
    })
    assert_not taskBoard.save, "Saved the task without a text"
  end
  
end
