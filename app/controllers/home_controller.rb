class HomeController < BaseController
  def index
    login_required
    
    unless @current_user.blank?
      #時刻情報の取得
      @time_info = []
      unless @current_user.json_time.blank?
        @time_info = @current_user.json_time
      end
      #薬の情報の取得
      @medicine_desc = @current_user.medicine_desc
      #薬の服用履歴を取得
      @history = DoneList.where(user_id: @current_user.id).where(is_reply: true).limit(10)
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
    unless @current_user.json_time.blank?
      j = @current_user.json_time
      j.delete_at(idx)
      logger.info("current json_data : #{j}")
       j = JSON.dump(j) if j.length > 1
      @current_user.update_attribute(:json_time, [])
      @current_user.update_attribute(:json_time, j) if j.length > 0
    end
    redirect_to home_index_path
  end
  
  def add_notify
    #通知エントリを追加
    login_required
    
    j = []
    unless @current_user.json_time.blank?
      j = @current_user.json_time
    end
    t = "#{params[:time(4i)]}:#{params[:time(5i)]}" 
    j.push({desc: params[:desc], time: t})
    j = JSON.dump(j) if j.length > 1
    #j.sort! {|a,b| Time.parse(a["time"]) <=> Time.parse(b["time"])}
   @current_user.update_attribute(:json_time, j)
   
   redirect_to home_index_path   
  end
  
  def extend
    login_required
    
    if @current_user.blank?
      return
    end
        
     j = [{}]
    unless @current_user.json_time.blank?
      j = @current_user.json_time
    end
    
    id = params[:id].to_i
    if @current_user.id != id
      flash[:alert] = "異なるユーザに対するリクエストです。requested_id:#{id} / current_user.id:#{@current_user.id}"
    else  
      h = params[:hour]
      m = params[:min]
      idx = params[:idx].to_i
  
      t = "#{h}:#{m}"
      j[idx]["extend"] = true
      j[idx]["extended_time"] = t
      j = JSON.dump(j) if j.length > 1
     @current_user.update({json_time: j})
     flash[:notice] = "再通知のリクエストを受け付けました。再通知の時間：#{h}:#{m}"
   end
  end
  
  def modify_medicine_desc
    login_required
    modify_desc = params[:medicine_desc]
    p modify_desc
    
    if @current_user.update({medicine_desc: modify_desc})
      flash[:notice] = "薬の種類を変更しました。"
       @medicine_desc = modify_desc;
    else
      flash[:alert] = "薬の種類を更新できませんでした。"
    end
    redirect_to home_index_path
     
  end
  
end