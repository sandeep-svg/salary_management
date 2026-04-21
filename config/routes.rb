Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route - serve the React app
  get "/" => "home#index"

  # API routes
  namespace :api do
    resources :employees
    get 'insights/salary_by_country', to: 'insights#salary_by_country'
    get 'insights/salary_by_job_title', to: 'insights#salary_by_job_title'
    get 'insights/overview', to: 'insights#overview'
  end
end
