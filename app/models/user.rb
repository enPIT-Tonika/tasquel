class User < ActiveRecord::Base
  has_many :done_list
  
  def self.create_with_omniauth(auth)
    instruction(auth['info']['nickname'])
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.screen_name = auth['info']['nickname']
      user.name = auth['info']['name']
    end
  end
  
  private
  def self.instruction(screen_name)
    msg = "#{screen_name}さん、登録ありがとう！登録した時間に「お薬のんだ？」とつぶやきます。のんだら返信してね！"
    p msg
    #$tw_client.update(msg)
  end
end
