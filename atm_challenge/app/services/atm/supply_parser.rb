# frozen_string_literal: true

module Services
  module Atm
    # Parse JSON into Hash, requiring the following:
    # {
    #   "caixa":{
    #     "caixaDisponivel":true,
    #     "notas":{
    #       "notasDez":100,
    #       "notasVinte":50,
    #       "notasCinquenta":10,
    #       "notasCem":30
    #     }
    #   }
    # }
    class SupplyParser
      def initialize(json_string:)
        @json_string = json_string
      end

      def call
        {
          available: parsed_json['caixaDisponivel'],
          bills: {
            10 => parsed_json['notas']['notasDez'],
            20 => parsed_json['notas']['notasVinte'],
            50 => parsed_json['notas']['notasCinquenta'],
            100 => parsed_json['notas']['notasCem']
          }
        }
      end

      private

      def parsed_json
        @parsed_json ||= begin
          parsed = JSON.parse(json_string)

          raise UnexpectedInput unless parsed.key?('caixa')

          parsed['caixa']
        end
      end

      attr_reader :json_string
    end
  end
end
