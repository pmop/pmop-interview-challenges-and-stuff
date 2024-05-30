# frozen_string_literal: true

class Atm
  def initialize(state = {})
    @state = state
  end

  def available?
    return false if state.empty?

    state[:available]
  end

  def full_cash_amount
    bills.to_a.reduce(0) { |sum, p| sum + p.reduce(:*) }
  end

  def bills
    state[:bills]
  end

  attr_accessor :state
end
