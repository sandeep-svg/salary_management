require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      employee = build(:employee)
      expect(employee).to be_valid
    end

    it 'requires first_name' do
      employee = build(:employee, first_name: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:first_name]).to include("can't be blank")
    end

    it 'requires last_name' do
      employee = build(:employee, last_name: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:last_name]).to include("can't be blank")
    end

    it 'requires email' do
      employee = build(:employee, email: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("can't be blank")
    end

    it 'requires unique email' do
      create(:employee, email: 'john@example.com')
      employee = build(:employee, email: 'john@example.com')
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("has already been taken")
    end

    it 'requires job_title' do
      employee = build(:employee, job_title: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("can't be blank")
    end

    it 'requires country' do
      employee = build(:employee, country: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("can't be blank")
    end

    it 'requires salary' do
      employee = build(:employee, salary: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("can't be blank")
    end

    it 'requires positive salary' do
      employee = build(:employee, salary: -1000)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("must be greater than 0")
    end

    it 'is valid with valid email format' do
      employee = build(:employee, email: 'test@example.com')
      expect(employee).to be_valid
    end

    it 'is invalid with invalid email format' do
      employee = build(:employee, email: 'invalid-email')
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to include("is invalid")
    end

    it 'rejects hire date in the future' do
      employee = build(:employee, hire_date: Date.today + 30)
      expect(employee).not_to be_valid
      expect(employee.errors[:hire_date]).to include("cannot be in the future")
    end

    it 'allows today as hire date' do
      employee = build(:employee, hire_date: Date.today)
      expect(employee).to be_valid
    end
  end

  describe 'associations' do
    it { should have_db_column(:first_name) }
    it { should have_db_column(:last_name) }
    it { should have_db_column(:email) }
    it { should have_db_column(:job_title) }
    it { should have_db_column(:department) }
    it { should have_db_column(:country) }
    it { should have_db_column(:salary) }
    it { should have_db_column(:hire_date) }
  end

  describe 'indexes' do
    it { should have_db_index(:country) }
    it { should have_db_index(:job_title) }
    it { have_db_index([:country, :job_title]) }
    it { should have_db_index(:email).unique(true) }
  end

  describe 'scopes' do
    let!(:usa_employee) { create(:employee, country: 'USA', salary: 80000) }
    let!(:uk_employee) { create(:employee, country: 'UK', salary: 60000) }
    let!(:engineer) { create(:employee, job_title: 'Software Engineer', country: 'USA', salary: 90000) }

    describe '.by_country' do
      it 'filters employees by country' do
        results = Employee.by_country('USA')
        expect(results).to include(usa_employee)
        expect(results).not_to include(uk_employee)
      end
    end

    describe '.by_job_title' do
      it 'filters employees by job title' do
        results = Employee.by_job_title('Software Engineer')
        expect(results).to include(engineer)
      end
    end

    describe '.search' do
      it 'searches by first name' do
        employee = create(:employee, first_name: 'John', last_name: 'Smith')
        results = Employee.search('John')
        expect(results).to include(employee)
      end

      it 'searches by last name' do
        employee = create(:employee, first_name: 'Jane', last_name: 'Smith')
        results = Employee.search('Smith')
        expect(results).to include(employee)
      end

      it 'searches by email' do
        employee = create(:employee, email: 'john.smith@example.com')
        results = Employee.search('john.smith')
        expect(results).to include(employee)
      end
    end
  end

  describe '#full_name' do
    it 'returns first and last name combined' do
      employee = build(:employee, first_name: 'John', last_name: 'Doe')
      expect(employee.full_name).to eq('John Doe')
    end
  end
end