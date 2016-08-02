json.path @root.path
json.archives @archives do |archive|
  json.id archive.id
  json.count archive.count
  json.size archive.size.to_i
end