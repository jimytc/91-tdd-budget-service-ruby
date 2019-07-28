# frozen_string_literal: true

require 'minitest/autorun'
require 'rr'
require 'date'

require_relative 'budget'
require_relative 'budget_repo'
require_relative 'budget_service'
require_relative 'period'

class BudgetServiceTest < Minitest::Test

  def setup
    super
    @repo = BudgetRepo.new
    @service = BudgetService.new(@repo)
  end

  def test_no_budget
    budget_should_be 0.0, date_of('20200401'), date_of('20200401')
  end

  def test_period_inside_budget_month
    given_budgets Budget.new('202004', 30)
    budget_should_be 1.0, date_of('20200401'), date_of('20200401')
  end

  def test_period_no_overlap_before_budget_first_day
    given_budgets Budget.new('202004', 30)
    budget_should_be 0.0, date_of('20200331'), date_of('20200331')
  end

  def test_period_no_overlap_after_budget_last_day
    given_budgets Budget.new('202004', 30)
    budget_should_be 0.0, date_of('20200501'), date_of('20200501')
  end

  def test_period_overlap_budget_last_day
    given_budgets Budget.new('202004', 30)
    budget_should_be 1.0, date_of('20200430'), date_of('20200501')
  end

  def test_period_cross_budget_month
    given_budgets Budget.new('202004', 30)
    budget_should_be 30.0, date_of('20200331'), date_of('20200501')
  end

  def test_invalid_period
    given_budgets Budget.new('202004', 30)
    budget_should_be 0.0, date_of('20200430'), date_of('20200401')
  end

  private

  def given_budgets(*budgets)
    stub(@repo).all_budgets { budgets }
  end

  def budget_should_be(expected, start_date, end_date)
    assert_in_delta expected, @service.query(start_date, end_date)
  end

  def date_of(date_str)
    Date.strptime(date_str, '%Y%m%d')
  end
end
