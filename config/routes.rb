Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    resources :employees
    get 'insights/salary_by_country', to: 'insights#salary_by_country'
    get 'insights/salary_by_job_title', to: 'insights#salary_by_job_title'
    get 'insights/overview', to: 'insights#overview'
  end

  # Catch-all for React SPA (must be last)
  get "*path" => "home#index"
end
