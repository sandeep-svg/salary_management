require 'rails_helper'
require 'rake'

RSpec.describe 'db:seed_employees' do
  before(:all) do
    Rake.application.rake_require 'tasks/seed'
    Rake::Task.define_task(:environment)
  end

  let(:task) { Rake::Task['db:seed_employees'] }

  before do
    Employee.delete_all
    task.reenable
  end

  it 'seeds 10,000 employees' do
    expect { task.invoke }.to change(Employee, :count).by(10_000)
  end

  it 'creates employees with valid attributes' do
    task.invoke
    employee = Employee.first
    expect(employee.first_name).to be_present
    expect(employee.last_name).to be_present
    expect(employee.email).to be_present
    expect(employee.email).to match(/@/)
    expect(employee.job_title).to be_present
    expect(employee.country).to be_present
    expect(employee.salary).to be > 0
  end

  it 'creates employees across multiple countries' do
    task.invoke
    countries = Employee.distinct.pluck(:country)
    expect(countries.size).to be > 1
  end

  it 'creates employees with various job titles' do
    task.invoke
    job_titles = Employee.distinct.pluck(:job_title)
    expect(job_titles.size).to be > 1
  end
end