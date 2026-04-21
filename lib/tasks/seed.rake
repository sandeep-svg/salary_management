namespace :db do
  desc "Seed the database with 10,000 employees"
  task seed_employees: :environment do

    puts "Starting employee seeding..."

    first_names = File.readlines('first_names.txt').map(&:chomp).compact.reject(&:empty?)
    last_names = File.readlines('last_names.txt').map(&:chomp).compact.reject(&:empty?)

    countries = ['USA', 'UK', 'Canada', 'Australia', 'Germany', 'France', 'Japan', 'India', 'Brazil', 'Singapore']
    job_titles = [
      'Software Engineer', 'Product Manager', 'Data Analyst', 'Designer',
      'HR Manager', 'Sales Representative', 'Marketing Specialist',
      'DevOps Engineer', 'QA Engineer', 'Technical Writer'
    ]
    departments = ['Engineering', 'Product', 'Sales', 'Marketing', 'HR', 'QA', 'Operations']
    domain = 'example.com'

    total = 10_000
    batch_size = 1_000

    first_names_size = first_names.size
    last_names_size = last_names.size

    Rails.logger.info "Loaded #{first_names_size} first names and #{last_names_size} last names"

    batch = []
    total.times do |i|
      first_name = first_names[rand(first_names_size)]
      last_name = last_names[rand(last_names_size)]
      country = countries[rand(countries.size)]
      job_title = job_titles[rand(job_titles.size)]
      department = departments[rand(departments.size)]

      base_salary = case job_title
      when 'Software Engineer' then rand(60_000..150_000)
      when 'Product Manager' then rand(70_000..160_000)
      when 'Data Analyst' then rand(50_000..100_000)
      when 'Designer' then rand(55_000..120_000)
      when 'HR Manager' then rand(60_000..130_000)
      when 'Sales Representative' then rand(45_000..120_000)
      when 'Marketing Specialist' then rand(50_000..110_000)
      when 'DevOps Engineer' then rand(65_000..140_000)
      when 'QA Engineer' then rand(50_000..100_000)
      when 'Technical Writer' then rand(45_000..95_000)
      else rand(50_000..100_000)
      end

      country_multiplier = case country
      when 'USA' then 1.0
      when 'UK' then 0.85
      when 'Canada' then 0.9
      when 'Australia' then 0.95
      when 'Germany' then 0.88
      when 'France' then 0.82
      when 'Japan' then 0.75
      when 'India' then 0.35
      when 'Brazil' then 0.45
      when 'Singapore' then 0.92
      else 1.0
      end

      salary = (base_salary * country_multiplier).to_i
      hire_date = Date.today - rand(0..3650)

      batch << {
        first_name: first_name,
        last_name: last_name,
        email: "#{first_name.downcase}.#{last_name.downcase}#{i}@#{domain}",
        job_title: job_title,
        department: department,
        country: country,
        salary: salary,
        hire_date: hire_date,
        created_at: Time.current,
        updated_at: Time.current
      }

      if batch.size >= batch_size
        Employee.insert_all!(batch)
        print "."
        batch = []
      end
    end

    if batch.any?
      Employee.insert_all!(batch)
      print "."
    end

    puts "\nSeeding complete! Created #{Employee.count} employees."
  end
end