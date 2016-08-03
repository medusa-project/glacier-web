And(/^there should be files with fields:$/) do |table|
  # table is a table.hashes.keys # => [:path, :mtime, :needs_archiving, :deleted]
  x = Root.first.file_infos.to_a
  table.hashes.each do |hash|
    expect(FileInfo.find_by(hash)).to be_a(FileInfo)
  end
end