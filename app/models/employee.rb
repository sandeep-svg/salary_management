class Employee < ApplicationRecord
  validates :first_name, :last_name, :email, :job_title, :country, :salary, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary, numericality: { greater_than: 0 }

  scope :by_country, ->(country) { where(country: country) }
  scope :by_job_title, ->(job_title) { where(job_title: job_title) }
  scope :search, ->(query) {
    sanitized = query.to_s.strip
    return none if sanitized.blank?

    where("LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email) LIKE :q", q: "%#{sanitized.downcase}%")
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
