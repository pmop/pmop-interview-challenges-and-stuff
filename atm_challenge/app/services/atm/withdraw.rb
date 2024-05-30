# frozen_string_literal: true

require_relative 'base_service'

module Services
  module Atm
    # Withdraw from ATM
    class Withdraw < BaseService
      # @return [Atm] with new state if successfull
      def call
        validate_atm_initialized!
        validate_atm_available!
        validate_enough_cash!
        validate_not_duplicate!

        atm.tap do |t|
          t.state = new_state(bills_to_withdraw!)
          Withdrawal.create(atm: atm, withdrawal: input)
        end
      end

      private

      # Redundant
      def validate_atm_initialized!
        raise AtmNotIntialized if atm.state.empty?
      end

      def validate_atm_available!
        raise AtmNotAvailable unless atm.available?
      end

      def validate_enough_cash!
        return if atm.full_cash_amount >= input[:amount]

        raise AtmNotEnoughCash
      end

      def validate_not_duplicate!
        raise AtmDuplicatedWithdrawal if Withdrawal.duplicate_withdrawal?(atm: atm, withdrawal: input)
      end

      def new_state(cash_change)
        {}.merge(atm.state).tap do |current_state|
          cash_change.each do |nominal, count|
            current_state[:bills][nominal] -= count
          end
        end
      end

      def bills_to_withdraw!
        cache_change = ChangeMaking.new(amount: input[:amount], limits: atm.state[:bills])

        cache_change.call.tap do |t|
          raise AtmNotEnoughCash if t.nil?
        end
      end
    end
  end
end
