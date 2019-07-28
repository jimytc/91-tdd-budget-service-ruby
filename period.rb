# frozen_string_literal: true

class Period
  attr_reader :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def days
    @end_date - @start_date + 1.0
  end
end
