json.root_path @root.path
json.file_path @file.path
json.archives @archives do |archive|
  json.id archive.id
  json.count archive.count
  json.size archive.size.to_i
end