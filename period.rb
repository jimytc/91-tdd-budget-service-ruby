# frozen_string_literal: true

class Period
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def overlapping_days(another)
    if end_date < another.start_date || start_date > another.end_date
      return 0.0
    end

    overlap_start = [start_date, another.start_date].max
    overlap_end = [end_date, another.end_date].min
    Period.new(overlap_start, overlap_end).days
  end

  def days
    end_date - start_date + 1.0
  end
end
