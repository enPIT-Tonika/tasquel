class BaseController < ApplicationController
  protect_from_forgery

#ログイン状況を確認
  def login_required
    #セッション情報としてuser idがあれば、@current_userにユーザ情報をセットして返す
    if session[:user_id]
      begin
        @current_user = User.find(session[:user_id])
      rescue
        #セッションを保存しているidが見つからなかった場合の対処
        redirect_to home_login_path
      end
    #なければtopページにリダイレクト
    else
      redirect_to home_login_path
    end
  end

end
