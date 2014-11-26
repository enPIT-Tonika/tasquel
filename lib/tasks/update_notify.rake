namespace :update_notify do
  desc "テスト用アカウントの通知時間として、現在時刻をセット"  
  task :setTestAccounts => :environment  do |task|
    jst = 60*60*9
    profiles = [
      {
        provider: "twitter",
        uid: 0000000001,
        screen_name: "test1",
        name: "test1",
        notify: true,
        json_time: [ { 
          desc: "テストその1", 
          time: (Time.now + jst).strftime("%H:%M") 
        } ]
      },
      {
        provider: "twitter",
        uid: 0000000002,
        screen_name: "test2",
        name: "test2",
        notify: true,
        json_time: [ { 
          desc: "テストその2", 
          time: (Time.now - 60 + jst).strftime("%H:%M") 
        } ]
      },
      {
        provider: "twitter",
        uid: 0000000003,
        screen_name: "test3",
        name: "test3",
        notify: true,
        json_time: [ { 
          desc: "テストその3", 
          time: (Time.now - 400 + jst).strftime("%H:%M") 
        } ]
      }, 
     {
        provider: "twitter",
        uid: 0000000004,
        screen_name: "test4",
        name: "test4",
        notify: true,
        json_time: [ { 
          desc: "テストその4", 
          time: (Time.now + 400 + jst).strftime("%H:%M") 
        } ]
      }             
    ]
    
    profiles.each do |profile|
        #テスト用アカウントのデータが、ユーザテーブルにすでに存在するかチェック
        s = profile[:screen_name] 
        testuser = User.find_by screen_name: s 
        if testuser != nil
          p "Updating #{s}"
          #アカウント情報があればUpdate
          testuser.update_attributes(profile)
        else
          #アカウント情報がなければ作成
          p  "Creating  #{s}" 
          User.create(profile)
        end
        p profile
    end
  end
end