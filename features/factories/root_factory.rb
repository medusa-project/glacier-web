FactoryGirl.define do
  factory :root do
    sequence(:path) {|n| "root_#{n}"}
  end
end