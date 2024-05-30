# frozen_string_literal: true

module Services
  module Atm
    # Parse JSON into Hash, requiring the following:
    # {
    #    "saque":{
    #       "valor":number,
    #       "horario":datetime
    #   }
    # }
    class WithdrawParser
      def initialize(json_string:)
        @json_string = json_string
      end

      def call
        { amount: parsed_json['valor'], datetime: Time.parse(parsed_json['horario']) }
      end

      private

      def parsed_json
        @parsed_json ||= begin
          parsed = JSON.parse(json_string)

          raise UnexpectedInput unless parsed.key?('saque')

          parsed['saque']
        end
      end

      attr_reader :json_string
    end
  end
end
