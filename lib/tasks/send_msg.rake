require 'twitter'

namespace :send_msg do
  desc "アカウントtasquelを使って、メッセージを自動ツイート"  
  task :first_notification => :environment  do |task|
    jst = 60 * 60 * 9 #UTCからの日本時間のoffset
    dest_accounts = User.where(notify: true) 
    t = Time.now #現在時刻の取得
    tt = t.hour * 60 + t.min #0時からの経過分数を取り出し 
    dest_accounts.each do |dest_account|
      p "#{dest_account.screen_name} :"
      begin
        next if dest_account.json_time.blank?
        json_time = dest_account.json_time
        #通知する時間かを確認する
        json_time.each_with_index do |j, idx|
          i = Time.parse(j["time"]) - jst
          n = i.hour * 60 + i.min #0時からの経過分数を取り出し 
          p "current_time: #{n}"
          p "projected time: #{tt}"
          if (tt + 5) >= n && n >= (tt - 5)
            p "tyring to tweet for #{dest_account.screen_name}"
            msg = create_msg(dest_account.screen_name, j["desc"])
            ret = $tw_client.update(msg)
            add_done_list_entry(ret.id, dest_account.id, j["desc"])
            break
          end
        end
      rescue => e
        Rails.logger.error"<<rake send_msg:first_notification ERROR : #{e.message}>>"
      end
     end
    end
    
    desc "自分の通知へのリプライを探し、薬を飲んだとみなす"  
    task :check_reply => :environment  do |task|
      jst = 60 * 60 * 9 #UTCからの日本時間のoffset
      t = Time.now + jst #現在時刻の取得
      begin
        lists = DoneList.where(is_reply: false)  #通知リストのうち、まだ返信がないエントリのみ抽出
        mentions = $tw_client.mentions #自分へのメンションを取得
        mentions.each do |m|
          mentioned_user = $tw_client.status(m.id)
          next if m.in_reply_to_tweet_id.nil?
          entry = lists.select{|item|item.tweet_id == m.in_reply_to_tweet_id.to_s}
          next if entry.length < 1
          p entry
          update_entry = DoneList.find(entry[0].id)
          dest_account= User.find(update_entry.user_id)
          update_entry.update_attributes({is_reply: true, reply_time: t})
          msg = create_reply_msg(dest_account.screen_name)
          p "tyring to tweet for #{dest_account.screen_name}"
          p msg
          $tw_client.update(msg)
        end
      rescue => e
         Rails.logger.error"<<rake send_msg:check_reply ERROR : #{e.message}>>"
      end
    end
    
    desc "薬が少なくなると通知する。（@tasquelからツイート)"
    task :go_to_hospital => :environment do |task|
        p "executing rake send_msg:go_to_hospital"     
        dest_accounts = User.all
        dest_accounts.each do |dest_account|
           p "#{dest_account.screen_name} :"
           next if dest_account.medicine_num.blank?
           num = dest_account.medicine_num
           num -= 1 if num > 0 #残り日数を-1
           begin
             dest_account.update_attributes({medicine_num: num}) #日数をアップデート
             next if dest_account.notify == false
             if num < 8 #日数を確認
              p "tyring to tweet for #{dest_account.screen_name}"
              msg = create_go_hosp_msg(dest_account.screen_name,num)
              $tw_client.update(msg) 
            end
          rescue => e
              Rails.logger.error"<<rake send_msg:go_to_hospital ERROR : #{e.message}>>"
          end 
        end 
    end
    
    #発言をランダムに作成
    def create_msg(account, desc=nil)
      if desc == nil
        desc = "薬の時間"
      else
        desc += "の薬の時間"
      end
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} #{desc}"
      if Rails.env == 'development'
        comment = "#{account} #{desc}"
      end
      if r == 0
        comment += "だよ！薬飲んだ？ by カプ君"
      else
        comment += "だぞ！飲まないとやばいぞ！ by タブ君"
      end
      return comment      
    end
    
    #病院へ行くことを促す発言をランダムに作成
    def create_go_hosp_msg(account, num)
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} "
      if num < 1
        comment += "もう薬がない"
      else
        comment += "あと#{num}日で薬がなくなる"
      end
      if r == 0
        comment += "よ！病院に行ってね！お薬手帳も忘れずに！ by カプ君"
      else
        comment += "ぞ！病院に行けよ！お薬手帳も持ってくんだぞ！ by タブ君"
      end
      return comment      
    end
    
    def create_reply_msg(account)
      r = Random.new_seed % 2 #乱数で0か1かを得る
      comment = "@#{account} "
      if r == 0
        comment += "薬ちゃんと飲んだんだね！さすが！ by カプ君"
      else
        comment += "薬ちゃんと飲んだな！えらいぜ！ by タブ君"
      end
      return comment      
    end
    
    def add_done_list_entry(tweet_id, user_id, desc)
      DoneList.create({
        user_id: user_id,
        tweet_id: tweet_id.to_s,
        desc: desc,
        is_reply: false
      })
    end
end
