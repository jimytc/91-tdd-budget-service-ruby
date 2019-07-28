# frozen_string_literal: true

class BudgetService

  def initialize(repo)
    @repo = repo
  end

  def query(start_date, end_date)
    period = Period.new(start_date, end_date)
    return 0.0 unless period.valid?

    budgets = @repo.all_budgets
    return 0.0 unless budgets

    budgets.map { |budget| budget.overlapping_amount(period) }
           .sum
  end
end
