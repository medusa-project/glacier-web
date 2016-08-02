json.array! @archives do |archive|
  json.extract! archive, :id, :count
  json.size archive.size.to_i
  json.root do
    json.path archive.root.path
  end
end