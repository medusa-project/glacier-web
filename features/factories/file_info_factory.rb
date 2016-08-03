FactoryGirl.define do
  factory :file_info do
    sequence(:path) {|n| "file_#{n}"}
    size 100
    mtime {Time.now.to_i}
    needs_archiving true
    deleted false
    root
  end
end