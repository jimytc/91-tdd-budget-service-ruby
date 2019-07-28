# frozen_string_literal: true

require 'minitest/autorun'
require 'rr'
require 'date'

require_relative 'budget_service'

class BudgetServiceTest < Minitest::Test

  def setup
    super
    @service = BudgetService.new
  end

  def test_no_budget
    budget_should_be(0, date_of('20200401'), date_of('20200401'))
  end

  private

  def budget_should_be(expected, start_date, end_date)
    assert_in_delta expected, @service.query(start_date, end_date), 0.00
  end

  def date_of(date_str)
    Date.strptime(date_str, '%Y%m%d')
  end
end