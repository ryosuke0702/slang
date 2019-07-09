FactoryBot.define do
  factory :comment do
    content { "MyText" }
    post_id { 1 }
    user_id { 1 }
  end
end
