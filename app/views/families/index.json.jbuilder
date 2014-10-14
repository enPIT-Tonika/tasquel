json.array!(@families) do |family|
  json.extract! family, :id, :name
  json.url family_url(family, format: :json)
end
