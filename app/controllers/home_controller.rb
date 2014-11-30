class HomeController < BaseController
  def index
    login_required
    
    unless @current_user.blank?
      #時刻情報の取得
      @time_info = []
      unless @current_user.json_time.blank?
        @time_info = @current_user.json_time
      end
      #通知ステータスの情報
      if @current_user.notify == true
          @notify_status = "ON"
          @link_msg = "OFFにする"
      else
          @notify_status = "OFF"
          @link_msg = "ONにする"
      end
      #薬の残り日数の取得
      @medicine_num = 30 #デフォルト値
      @medicine_num = @current_user.medicine_num unless @current_user.medicine_num.blank?
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
    modify_num = params[:medicine_num]
    p modify_num
    #値の更新
    if @current_user.update({medicine_num: modify_num})
      flash[:notice] = "薬の残り日数を更新しました。"
    else
      flash[:alert] = "薬の残り日数を更新できませんでした。"
    end
    redirect_to home_index_path
    
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
  
  def extend
    login_required
    
     j = []
    unless @current_user.json_time.blank?
      j = @current_user.json_time
    end
    
    h = params[:hour]
    m = params[:min]
    t = "#{h}:#{m}"
    j.push({extend: true, extended_time: t})
    j = JSON.dump(j) if j.length > 1
   @current_user.update_attribute(:json_time, j)
  end
end