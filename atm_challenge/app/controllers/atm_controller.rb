# frozen_string_literal: true

module Controllers
  class AtmController
    def initialize
      @atm = Atm.new
    end

    def supply(json)
      exec_service(:supply).call(atm, json)
    end

    def withdraw(json)
      exec_service(:withdraw).call(atm, json)
    end

    def reset
      @atm = Atm.new
      Withdrawal.clear
    end

    def state
      Formatter.format_for_output(atm).merge(errors: [])
    end

    private

    def exec_service(command)
      command = command.to_s.capitalize
      parser_klass = Object.const_get("::Services::Atm::#{command}Parser")
      service_klass = Object.const_get("::Services::Atm::#{command}")

      proc do |atm, json|
        input = parser_klass.new(json_string: json).call
        errors = []
        begin
          service_klass.new(atm:, input:).call
        rescue StandardError => e
          errors.unshift(e.message)
        end

        Formatter.format_for_output(atm).merge(errors:)
      end
    end

    attr_reader :atm
  end
end
