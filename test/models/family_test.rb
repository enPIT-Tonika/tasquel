require 'test_helper'
require 'shoulda'

class FamilyTest < ActiveSupport::TestCase
#class FamilyTest < ActiveRecord::TestCase
  # task_boardテーブルとの関連を確認
  should have_many(:task_boards)
end
