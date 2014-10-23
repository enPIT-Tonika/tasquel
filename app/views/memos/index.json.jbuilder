json.array!(@memos) do |memo|
  json.extract! memo, :id, :taskmemo
  json.url memo_url(memo, format: :json)
end
