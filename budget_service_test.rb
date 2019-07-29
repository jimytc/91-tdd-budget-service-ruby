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
    given_no_budget do
      when_period_is date_of('20200401'), date_of('20200401') do
        budget_should_be 0.0
      end
    end
  end

  def test_period_inside_budget_month
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200401'), date_of('20200401') do
        budget_should_be 1.0
      end
    end
  end

  def test_period_no_overlap_before_budget_first_day
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200331'), date_of('20200331') do
        budget_should_be 0.0
      end
    end
  end

  def test_period_no_overlap_after_budget_last_day
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200501'), date_of('20200501') do
        budget_should_be 0.0
      end
    end
  end

  def test_period_overlap_budget_last_day
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200430'), date_of('20200501') do
        budget_should_be 1.0
      end
    end
  end

  def test_period_cross_budget_month
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200331'), date_of('20200501') do
        budget_should_be 30.0
      end
    end
  end

  def test_invalid_period
    given_budgets Budget.new('202004', 30) do
      when_period_is date_of('20200430'), date_of('20200401') do
        budget_should_be 0.0
      end
    end
  end

  def test_daily_amount_10
    given_budgets Budget.new('202004', 300) do
      when_period_is date_of('20200401'), date_of('20200402') do
        budget_should_be 20.0
      end
    end
  end

  def test_multiple_budgets
    given_budgets Budget.new('202003', 310), Budget.new('202004', 30), Budget.new('202005', 3100) do
      when_period_is date_of('20200330'), date_of('20200501') do
        budget_should_be 150.0
      end
    end
  end

  private

  def given_no_budget(&block)
    given_budgets &block
  end

  def given_budgets(*budgets)
    stub(@repo).all_budgets { budgets }
    yield if block_given?
  end

  def when_period_is(start_date, end_date)
    block = yield if block_given?
    block.call(@service.query(start_date, end_date)) if block.respond_to?(:call)
  end

  def budget_should_be(expected)
    ->(actual) { assert_in_delta expected, actual }
  end

  def date_of(date_str)
    Date.strptime(date_str, '%Y%m%d')
  end
end
