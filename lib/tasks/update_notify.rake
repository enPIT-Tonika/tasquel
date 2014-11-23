namespace :update_notify do
  desc "テスト用アカウントの通知時間として、現在時刻をセット"  
  task :setCurrentTime => :environment  do |task|
    t = Time.now.strftime("%H:%M") #現在の時刻情報を取得
    #テスト用アカウント（tasquel)のデータが、ユーザテーブルにすでに存在するかチェック
    testuser = User.find_by screen_name: "tasquel" 
    if testuser != nil
      #アカウント情報があればUpdate
      testuser.update_attributes({
        notify: true,
        json_time: [{
          desc: "test", time: t
        }]
      })
    else
      #アカウント情報がなければ作成
      User.create(
        provider: "twitter",
        uid: 0000000000,
        screen_name: "tasquel",
        name: "tasquel",
        notify: true,
        json_time: [ { 
          desc: "test", time: t  
      } ]
    )
    end
  end
end
