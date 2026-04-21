# Architecture Decision Records

## ADR-001: Tech Stack Selection

**Decision**: Rails 8 API mode + React + SQLite

**Rationale**:
- Rails 8 provides modern defaults and better performance
- API mode keeps backend clean for JSON responses
- React with Vite for fast frontend development
- SQLite for demo portability (10k records is manageable)

**Alternatives Considered**:
- Next.js: Good but less familiar with Ruby ecosystem
- PostgreSQL: Overkill for demo, adds setup complexity

---

## ADR-002: Asset Pipeline

**Decision**: Vite builds to public/assets, Rails serves static files

**Rationale**:
- Single port (3000) for both frontend and API
- No need for separate dev server
- Precompilation works with `rails assets:precompile`

**Trade-offs**:
- Development: Assets served from public/assets
- Production: Works but could use CDN in future

---

## ADR-003: TDD Approach

**Decision**: Tests first, then implementation

**Rationale**:
- Write failing test
- Implement feature to pass
- Refactor while keeping tests green

**Test Coverage**:
- Model validations & scopes
- API endpoints (CRUD + insights)
- Seed task

---

## ADR-004: Employee Data Model

**Decision**: Minimal required fields + business logic

**Fields**:
- first_name, last_name, email (required)
- job_title, department, country (categorization)
- salary (decimal for precision)
- hire_date (with future date validation)

**Indexes**: email (unique), country, job_title, composite(country, job_title)

---

## ADR-005: Search Implementation

**Decision**: Database-level search with ILIKE

**Rationale**:
- Simple, works with SQLite
- Handles spaces/edge cases in model scope
- Frontend trims input before API call

**Trade-off**: For 10k records, this works. For millions, would need Elasticsearch.
