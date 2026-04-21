module Api
  class EmployeesController < ApplicationController
    before_action :set_employee, only: [:show, :update, :destroy]

    def index
      employees = Employee.all
      employees = employees.by_country(params[:country]) if params[:country].present?
      employees = employees.by_job_title(params[:job_title]) if params[:job_title].present?
      employees = employees.search(params[:search]) if params[:search].present?

      page = params[:page]&.to_i || 1
      per_page = [params[:per_page]&.to_i || 20, 100].min

      employees = employees.order(created_at: :desc).limit(per_page).offset((page - 1) * per_page)

      render json: {
        data: employees.map { |e| employee_json(e) },
        meta: {
          current_page: page,
          per_page: per_page,
          total: Employee.count
        }
      }
    end

    def show
      render json: { data: employee_json(@employee) }
    end

    def create
      @employee = Employee.new(employee_params)

      if @employee.save
        render json: { data: employee_json(@employee) }, status: :created
      else
        render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @employee.update(employee_params)
        render json: { data: employee_json(@employee) }
      else
        render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @employee.destroy
      head :no_content
    end

    private

    def set_employee
      @employee = Employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Employee not found' }, status: :not_found
    end

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :email, :job_title, :department, :country, :salary, :hire_date)
    end

    def employee_json(employee)
      {
        id: employee.id.to_s,
        type: 'employee',
        attributes: {
          first_name: employee.first_name,
          last_name: employee.last_name,
          full_name: employee.full_name,
          email: employee.email,
          job_title: employee.job_title,
          department: employee.department,
          country: employee.country,
          salary: employee.salary.to_f,
          hire_date: employee.hire_date&.iso8601,
          created_at: employee.created_at.iso8601,
          updated_at: employee.updated_at.iso8601
        }
      }
    end
  end
end
