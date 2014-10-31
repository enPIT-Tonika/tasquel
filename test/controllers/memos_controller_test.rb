require 'test_helper'

class MemosControllerTest < ActionController::TestCase
  setup do
    @memo = memos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memo" do
    assert_difference('Memo.count') do
      post :create, memo: { taskmemo: @memo.taskmemo }
    end

    assert_redirected_to controller: "task_boards", action: "index"
  end

  test "should show memo" do
    get :show, id: @memo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @memo
    assert_response :success
  end

  test "should update memo" do
    patch :update, id: @memo, memo: { taskmemo: @memo.taskmemo }
    assert_redirected_to memo_path(assigns(:memo))
  end

  test "should destroy memo" do
    assert_difference('Memo.count', -1) do
      delete :destroy, id: @memo
    end

    assert_redirected_to memos_path
  end
end
