require 'rails_helper'

RSpec.describe '/api/employees', type: :request do
  let!(:employee) { create(:employee) }

  describe 'GET /api/employees' do
    it 'returns all employees' do
      get '/api/employees'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
    end

    it 'supports pagination' do
      get '/api/employees', params: { page: 1, per_page: 10 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['meta']['current_page']).to eq(1)
    end

    it 'filters by country' do
      get '/api/employees', params: { country: 'USA' }
      expect(response).to have_http_status(:ok)
    end

    it 'filters by job_title' do
      get '/api/employees', params: { job_title: 'Software Engineer' }
      expect(response).to have_http_status(:ok)
    end

    it 'searches employees' do
      get '/api/employees', params: { search: 'John' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/employees/:id' do
    it 'returns a specific employee' do
      get "/api/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['id']).to eq(employee.id.to_s)
    end

    it 'returns 404 for non-existent employee' do
      get '/api/employees/999999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/employees' do
    let(:valid_attributes) {
      {
        employee: {
          first_name: 'Jane',
          last_name: 'Smith',
          email: 'jane.smith@example.com',
          job_title: 'Product Manager',
          department: 'Product',
          country: 'UK',
          salary: 85000,
          hire_date: '2024-01-15'
        }
      }
    }

    it 'creates an employee' do
      expect {
        post '/api/employees', params: valid_attributes, as: :json
      }.to change(Employee, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns validation errors for invalid data' do
      post '/api/employees', params: { employee: { first_name: '' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/employees/:id' do
    let(:update_attributes) {
      { employee: { first_name: 'Updated' } }
    }

    it 'updates an employee' do
      patch "/api/employees/#{employee.id}", params: update_attributes, as: :json
      expect(response).to have_http_status(:ok)
      employee.reload
      expect(employee.first_name).to eq('Updated')
    end

    it 'returns 404 for non-existent employee' do
      patch '/api/employees/999999', params: update_attributes, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/employees/:id' do
    it 'deletes an employee' do
      expect {
        delete "/api/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 for non-existent employee' do
      delete '/api/employees/999999'
      expect(response).to have_http_status(:not_found)
    end
  end
end