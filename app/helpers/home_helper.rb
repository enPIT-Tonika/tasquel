module HomeHelper
  def generate_desc(desc = nil)
    msg = "お薬を飲みました。"
    unless desc.blank?
      msg = "#{desc}のお薬を飲みました。"
    end
    return msg
  end
end
