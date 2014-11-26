class HomeController < BaseController
  def index
    login_required
    
    #通知ステータスの情報
    unless @current_user.blank?
      if @current_user.notify == true
          @notify_status = "ON"
          @link_msg = "OFFにする"
          #時刻情報の取得
          @time_info = []
          unless @current_user.json_time.blank?
            @time_info = @current_user.json_time
          end
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
    
    @modify_num = params[:medicine_num]
    
    # ここから取得、登録する箇所がまだです。
  end

  def del_notify
    #指定された通知エントリを削除
    login_required
    
    idx = params[:idx].to_i
    j = @current_user.json_time
    j.delete_at(idx)
    logger.info("current json_data : #{j}")
     j = JSON.dump(j) if j.length > 1
    @current_user.update_attribute(:json_time, [])
    @current_user.update_attribute(:json_time, j) if j.length > 0
    
    redirect_to home_index_path
  end
  
  def add_notify
    #通知エントリを追加
    login_required
    j = []
    unless @current_user.json_time.blank?
      j = @current_user.json_time
    end
    t = params[:time]
    j.push({desc: params[:desc], time: params[:time]})
    j = JSON.dump(j) if j.length > 1
    #j.sort! {|a,b| Time.parse(a["time"]) <=> Time.parse(b["time"])}
   @current_user.update_attribute(:json_time, j)
   
   redirect_to home_index_path   
  end
end