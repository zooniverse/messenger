FactoryGirl.define do
  factory :transcription do
    sequence :id
    status "unreviewed"
    text Faker::Lorem.paragraph(5)
    project
  end
end
