# frozen_string_literal: true

class Budget
  def initialize(year_month, amount)
    @year_month = year_month
    @amount = amount
  end

  def first_day
    Date.strptime("#{@year_month}01", '%Y%m%d')
  end
end
