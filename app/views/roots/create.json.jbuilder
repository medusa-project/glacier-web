json.status "CREATED"
json.root do
  json.extract! @root, :path
end