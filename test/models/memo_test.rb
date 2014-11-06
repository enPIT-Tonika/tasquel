require 'test_helper'

class MemoTest < ActiveSupport::TestCase
  # taskmemoが空の場合は投稿を許可しない
  test "The post should not accept when the taskmemo is null" do
    memo = Memo.new({taskmemo: ''})
    assert_not memo.save, "Saved the memo without a text"
  end
end
