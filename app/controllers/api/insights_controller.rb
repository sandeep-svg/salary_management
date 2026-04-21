module Api
  class InsightsController < ApplicationController
    def salary_by_country
      insights = Employee.group(:country).select(
        'country,
         COUNT(*) as employee_count,
         MIN(salary) as min_salary,
         MAX(salary) as max_salary,
         AVG(salary) as avg_salary'
      ).order(:country)

      render json: {
        data: insights.map { |i| {
          country: i.country,
          employee_count: i.employee_count,
          min_salary: i.min_salary.to_f,
          max_salary: i.max_salary.to_f,
          avg_salary: i.avg_salary.to_f.round(2)
        } }
      }
    end

    def salary_by_job_title
      employees = Employee.all
      employees = employees.by_country(params[:country]) if params[:country].present?

      insights = employees.group(:country, :job_title).select(
        'country,
         job_title,
         COUNT(*) as employee_count,
         AVG(salary) as avg_salary,
         MIN(salary) as min_salary,
         MAX(salary) as max_salary'
      ).order(:country, :job_title)

      render json: {
        data: insights.map { |i| {
          country: i.country,
          job_title: i.job_title,
          employee_count: i.employee_count,
          avg_salary: i.avg_salary.to_f.round(2),
          min_salary: i.min_salary.to_f,
          max_salary: i.max_salary.to_f
        } }
      }
    end

    def overview
      stats = Employee.select(
        'COUNT(*) as total_employees,
         SUM(salary) as total_payroll,
         AVG(salary) as avg_salary,
         MIN(salary) as min_salary,
         MAX(salary) as max_salary'
      ).first

      render json: {
        data: {
          total_employees: stats.total_employees,
          total_payroll: stats.total_payroll.to_f.round(2),
          avg_salary: stats.avg_salary.to_f.round(2),
          min_salary: stats.min_salary.to_f,
          max_salary: stats.max_salary.to_f,
          countries_count: Employee.distinct.count(:country),
          job_titles_count: Employee.distinct.count(:job_title)
        }
      }
    end
  end
end