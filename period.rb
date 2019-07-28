# frozen_string_literal: true

class Period
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def valid?
    start_date <= end_date
  end

  def overlapping_days(another)
    overlap_start = [start_date, another.start_date].max
    overlap_end = [end_date, another.end_date].min
    overlap_period = Period.new(overlap_start, overlap_end)
    overlap_period.valid? && overlap_period.days || 0.0
  end

  def days
    end_date - start_date + 1.0
  end
end
