require 'rails_helper'

RSpec.describe '/api/insights', type: :request do
  let!(:usa_employee1) { create(:employee, country: 'USA', job_title: 'Software Engineer', salary: 80000) }
  let!(:usa_employee2) { create(:employee, country: 'USA', job_title: 'Software Engineer', salary: 90000) }
  let!(:uk_employee1) { create(:employee, country: 'UK', job_title: 'Product Manager', salary: 70000) }
  let!(:uk_employee2) { create(:employee, country: 'UK', job_title: 'Product Manager', salary: 75000) }

  describe 'GET /api/insights/salary_by_country' do
    it 'returns salary insights grouped by country' do
      get '/api/insights/salary_by_country'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)

      usa_data = json['data'].find { |c| c['country'] == 'USA' }
      expect(usa_data['min_salary']).to eq(80000)
      expect(usa_data['max_salary']).to eq(90000)
      expect(usa_data['avg_salary']).to eq(85000)
    end

    it 'includes employee count per country' do
      get '/api/insights/salary_by_country'
      json = JSON.parse(response.body)
      usa_data = json['data'].find { |c| c['country'] == 'USA' }
      expect(usa_data['employee_count']).to eq(2)
    end
  end

  describe 'GET /api/insights/salary_by_job_title' do
    it 'returns salary insights by job title and country' do
      get '/api/insights/salary_by_job_title', params: { country: 'USA' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
    end

    it 'filters by country when provided' do
      get '/api/insights/salary_by_job_title', params: { country: 'USA' }
      json = JSON.parse(response.body)
      countries = json['data'].map { |d| d['country'] }.uniq
      expect(countries).to contain_exactly('USA')
    end

    it 'calculates correct average salary' do
      get '/api/insights/salary_by_job_title', params: { country: 'USA' }
      json = JSON.parse(response.body)
      engineer_data = json['data'].find { |d| d['job_title'] == 'Software Engineer' && d['country'] == 'USA' }
      expect(engineer_data['avg_salary']).to eq(85000)
    end
  end

  describe 'GET /api/insights/overview' do
    it 'returns overall salary statistics' do
      get '/api/insights/overview'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to have_key('total_employees')
      expect(json['data']).to have_key('total_payroll')
      expect(json['data']).to have_key('avg_salary')
      expect(json['data']).to have_key('min_salary')
      expect(json['data']).to have_key('max_salary')
      expect(json['data']).to have_key('countries_count')
      expect(json['data']).to have_key('job_titles_count')
    end
  end
end