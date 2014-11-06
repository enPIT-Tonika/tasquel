module ApplicationHelper
   #改行コードを<br>タグに変換するヘルパ
  def addBr(t)
    #既存の文字列のhtmlタグは無効化する（セキュリティのため）
    t = h(t)
    #テキストの改行コードをbrタグに変換
    return t.gsub(/(\r\n|\r|\n)/, "<br />")
  end
end
