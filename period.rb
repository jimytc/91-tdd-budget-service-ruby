# frozen_string_literal: true

class Period
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def overlapping_days(budget)
    if end_date < budget.first_day || start_date > budget.last_day
      return 0.0
    end

    overlap_start = [start_date, budget.first_day].max
    overlap_end = [end_date, budget.last_day].min
    Period.new(overlap_start, overlap_end).days
  end

  def days
    end_date - start_date + 1.0
  end
end
