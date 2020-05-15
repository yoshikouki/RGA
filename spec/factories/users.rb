FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:username) { |n| "テスト#{n}" }
    sequence(:email) { |n| "test-#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { 10.days.ago }
  end
end

