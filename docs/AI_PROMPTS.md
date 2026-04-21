# AI Tools & Prompts Used

## Project Prompts

### Initial Prompt
"build a salary management tool for organization with 10000 employees using Rails and React, use latest stable versions, prefer asset precompilation and TDD approach"

### Key Prompts During Development

1. **Setup Rails 8**
   - Create new Rails app with esbuild, tailwind, sqlite
   - Configure RSpec for testing

2. **Employee Model**
   - Generate model with fields: first_name, last_name, email, job_title, department, country, salary, hire_date
   - Add validations and scopes

3. **API CRUD**
   - Create employees API controller
   - Add salary insights endpoints

4. **Frontend**
   - Set up Vite + React + Tailwind
   - Create Employee management UI
   - Create Insights dashboard

5. **Seeding**
   - Create seeding script for 10k employees
   - Use first_names.txt + last_names.txt for random generation

6. **Asset Precompilation**
   - Configure jsbundling-rails, cssbundling-rails
   - Fix asset serving issues
   - Add catch-all route for React Router

### Issues Fixed During Development

- Search with trailing spaces: Added trim in frontend + blank check in backend
- Hardcoded asset paths: Removed, use fixed filenames from Vite
- HTML escaping: Added `.html_safe` to render
- Route issues: Added catch-all for React SPA
- Future hire dates: Added validation

## Tools Used

- **Language Model**: opencode/big-pickle
- **Code Search**: Exa Code API for documentation lookup
- **Web Search**: For checking Rails/React best practices

## Approach

1. **Incremental commits** - Show TDD evolution
2. **Tests first** - Model specs before implementation
3. **Working feature** - Commit at each milestone
4. **Minimal viable** - Don't over-engineer