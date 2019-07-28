# frozen_string_literal: true

class Budget
  def initialize(year_month, amount)
    @year_month = year_month
    @amount = amount
  end

  def overlapping_amount(period)
    daily_amount * period.overlapping_days(budget_period)
  end

  def daily_amount
    1.0 * @amount / days
  end

  def days
    budget_period.days
  end

  def budget_period
    Period.new(first_day, last_day)
  end

  def first_day
    Date.strptime("#{@year_month}01", '%Y%m%d')
  end

  def last_day
    first_day.next_month - 1
  end
end
