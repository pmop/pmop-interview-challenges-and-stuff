# frozen_string_literal: true

module Services
  module Atm
    # Base ATM Service
    class BaseService
      # @param atm [Atm] instance
      # @param input [Hash]
      def initialize(atm:, input:)
        @atm = atm
        @input = input
      end

      private

      attr_reader :atm, :input
    end
  end
end
