# frozen_string_literal: true

require_relative 'base_service'

module Services
  module Atm
    # Supply an ATM instance with bills
    class Supply < BaseService
      def call
        validate_availability!

        atm.tap { |t| t.state = input }
      end

      private

      def validate_availability!
        return if atm.state.empty?

        raise ::AtmInUseError if atm.available?
      end

      # Eu vi depois no documento que não é p/ acumular, mas essa é a implementação caso fosse
      # def new_state
      #   return input if atm.state.empty?

      #   atm.state.tap do |state|
      #     state[:bills].default = 0

      #     input[:bills].each do |nominal, count|
      #       state[:bills][nominal] += count
      #     end

      #     state[:available] = input[:available]
      #   end
      # end
    end
  end
end
