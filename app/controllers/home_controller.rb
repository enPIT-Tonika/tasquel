class HomeController < BaseController
  def index
    login_required
    
    unless @current_user.blank?
      if @current_user.notify == true
          @notify_status = "ON"
          @link_msg = "OFFにする"
      else
          @notify_status = "OFF"
          @link_msg = "ONにする"
       end
    end
  end
  
  def login
  end
  
  def toggle_notify
    #通知のON/OFFを切り替える
    login_required
    
    if @current_user.notify == true
      @current_user.update_attribute(:notify, false)
   else
     @current_user.update_attribute(:notify,  true)
    end
    redirect_to home_index_path
  end
  
  #日時の登録を確認
  def modify_medicine_num
    #薬の残りの日数の登録
    login_required #要ログインの項目
    
    # ここから取得、登録する箇所がまだです。
  end
end