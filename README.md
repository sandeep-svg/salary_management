# Salary Manager

A full-stack salary management tool for HR managers to manage 10,000 employees and view salary insights.

## Tech Stack

- **Backend**: Ruby on Rails 8.1.3 (API mode)
- **Database**: SQLite3
- **Frontend**: React 18 + Tailwind CSS
- **Build**: Vite + Sprockets for asset precompilation
- **Testing**: RSpec

## Features

### Employee Management
- Add, View, Update, Delete employees
- Search by name or email
- Filter by country
- Pagination (20 per page)

### Salary Insights
- Minimum, maximum, average salary by country
- Average salary by job title in each country
- Overall statistics dashboard

## Getting Started

### Prerequisites
- Ruby 3.3+
- Rails 8.1.3
- Node.js 18+
- SQLite3

### Installation

```bash
# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
npm install

# Set up the database
rails db:create db:migrate

# Seed with 10,000 employees
rails db:seed_employees
```

### Running the Application

```bash
# Single port serves both frontend and API
rails s

# Assets are precompiled, no separate frontend server needed
# API available at http://localhost:3000/api/employees
```

### Production Build

```bash
# Precompile assets
RAILS_ENV=production rails assets:precompile

# Start server
rails s -e production
```

## API Endpoints

### Employees
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/employees | List employees (paginated) |
| GET | /api/employees/:id | Get employee |
| POST | /api/employees | Create employee |
| PATCH | /api/employees/:id | Update employee |
| DELETE | /api/employees/:id | Delete employee |

### Query Parameters
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 20, max: 100)
- `country` - Filter by country
- `job_title` - Filter by job title
- `search` - Search by name/email

### Salary Insights
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/insights/salary_by_country | Min/max/avg by country |
| GET | /api/insights/salary_by_job_title | Avg by job title & country |
| GET | /api/insights/overview | Overall statistics |

## Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/employee_spec.rb
```

## Seed Data

The seeding script generates 10,000 employees with:
- Realistic first and last names
- 10 job titles across 7 departments
- 10 countries with realistic salary ranges
- Randomized hire dates

Run the seed:
```bash
rails db:seed_employees
```

## Project Structure

```
salary_manager/
├── app/
│   ├── controllers/api/    # API controllers
│   ├── models/             # ActiveRecord models
│   ├── views/              # Rails views
│   └── javascript/         # React components
├── spec/                   # RSpec tests
├── lib/tasks/              # Rake tasks
├── public/assets/          # Compiled assets
└── db/                     # Database & migrations
```

## License

MIT
