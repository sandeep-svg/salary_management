FactoryBot.define do
  factory :employee do
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name) { |n| "Doe#{n}" }
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    job_title { "Software Engineer" }
    department { "Engineering" }
    country { "USA" }
    salary { 75000.00 }
    hire_date { Date.today }
  end
end
