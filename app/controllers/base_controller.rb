class BaseController < ApplicationController
  protect_from_forgery

#ログイン状況を確認
  def login_required
    #セッション情報としてuser idがあれば、@current_userにユーザ情報をセットして返す
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    #なければtopページにリダイレクト
    else
      redirect_to home_login_path
    end
  end

end
