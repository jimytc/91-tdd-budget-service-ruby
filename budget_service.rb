# frozen_string_literal: true

class BudgetService

  def initialize(repo)
    @repo = repo
  end

  def query(start_date, end_date)
    period = Period.new(start_date, end_date)
    budgets = @repo.all_budgets
    if budgets&.any?
      return period.overlapping_days(budgets.first)
    end

    0.0
  end
end
