import { useState, useEffect } from 'react'
import axios from 'axios'

export default function Insights() {
  const [overview, setOverview] = useState(null)
  const [salaryByCountry, setSalaryByCountry] = useState([])
  const [salaryByJob, setSalaryByJob] = useState([])
  const [selectedCountry, setSelectedCountry] = useState('')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchData()
  }, [])

  useEffect(() => {
    fetchJobTitles()
  }, [selectedCountry])

  const fetchData = async () => {
    setLoading(true)
    try {
      const [overviewRes, countryRes] = await Promise.all([
        axios.get('/api/insights/overview'),
        axios.get('/api/insights/salary_by_country')
      ])
      setOverview(overviewRes.data.data)
      setSalaryByCountry(countryRes.data.data)
      if (countryRes.data.data.length > 0) {
        setSelectedCountry(countryRes.data.data[0].country)
      }
    } catch (error) {
      console.error('Error fetching insights:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchJobTitles = async () => {
    if (!selectedCountry) return
    try {
      const response = await axios.get('/api/insights/salary_by_job_title', {
        params: { country: selectedCountry }
      })
      setSalaryByJob(response.data.data)
    } catch (error) {
      console.error('Error fetching job titles:', error)
    }
  }

  if (loading) {
    return <div className="text-center py-8 text-gray-500">Loading...</div>
  }

  return (
    <div>
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Salary Insights</h2>

      {overview && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
          <StatCard title="Total Employees" value={overview.total_employees.toLocaleString()} />
          <StatCard title="Total Payroll" value={`$${overview.total_payroll.toLocaleString()}`} />
          <StatCard title="Average Salary" value={`$${overview.avg_salary.toLocaleString()}`} />
          <StatCard title="Countries" value={overview.countries_count} />
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold mb-4">Salary by Country</h3>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Country</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Employees</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Min</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Max</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Average</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {salaryByCountry.map((item) => (
                  <tr key={item.country} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium text-gray-900">{item.country}</td>
                    <td className="px-4 py-3 text-right text-gray-600">{item.employee_count}</td>
                    <td className="px-4 py-3 text-right text-gray-600">${item.min_salary?.toLocaleString()}</td>
                    <td className="px-4 py-3 text-right text-gray-600">${item.max_salary?.toLocaleString()}</td>
                    <td className="px-4 py-3 text-right font-medium text-gray-900">${item.avg_salary?.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="bg-white shadow rounded-lg p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold">Salary by Job Title</h3>
            <select
              value={selectedCountry}
              onChange={(e) => setSelectedCountry(e.target.value)}
              className="px-3 py-1 border border-gray-300 rounded-md text-sm"
            >
              {salaryByCountry.map((item) => (
                <option key={item.country} value={item.country}>{item.country}</option>
              ))}
            </select>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Job Title</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Employees</th>
                  <th className="px-4 py-2 text-right text-xs font-medium text-gray-500 uppercase">Average</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {salaryByJob.map((item) => (
                  <tr key={`${item.country}-${item.job_title}`} className="hover:bg-gray-50">
                    <td className="px-4 py-3 font-medium text-gray-900">{item.job_title}</td>
                    <td className="px-4 py-3 text-right text-gray-600">{item.employee_count}</td>
                    <td className="px-4 py-3 text-right font-medium text-gray-900">${item.avg_salary?.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}

function StatCard({ title, value }) {
  return (
    <div className="bg-white shadow rounded-lg p-6">
      <div className="text-sm font-medium text-gray-500">{title}</div>
      <div className="mt-2 text-3xl font-semibold text-gray-900">{value}</div>
    </div>
  )
}