require 'test_helper'
require 'shoulda'

class TaskBoardTest < ActiveSupport::TestCase
#class TaskBoardTest < ActiveRecord::TestCase
  #familyテーブルとの関連を確認
  should belong_to(:family)
end
