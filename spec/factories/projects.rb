FactoryGirl.define do
  factory :project do
    sequence :id
    slug{ "user/#{ id }" }
  end
end
