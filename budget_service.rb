# frozen_string_literal: true

class BudgetService

  def initialize(repo)
    @repo = repo
  end

  def query(start_date, end_date)
    period = Period.new(start_date, end_date)
    budgets = @repo.all_budgets
    if budgets&.any?
      budget = budgets.first
      if period.end_date < budget.first_day
        return 0.0
      end
      if period.start_date > budget.last_day
        return 0.0
      end
      return period.days
    end

    0.0
  end
end
