# frozen_string_literal: true

require_relative '../../config/application'
require 'minitest/autorun'
::AtmChallenge::Application.autoload

class TestAtmController < Minitest::Test
  def setup
    @app = ::Controllers::AtmController.new

    @supply1 = File.read('test/fixtures/supply1.json')
    @supply2 = File.read('test/fixtures/supply2.json')
  end

  def test_supply_violation
    @app.supply(@supply1)

    out = @app.supply(@supply2)

    expected = {
      caixa: {
        'caixaDisponivel': true,
        notas: {
          'notasDez': 100,
          'notasVinte': 50,
          'notasCinquenta': 10,
          'notasCem': 30
        }
      },
      errors: ['caixa-em-uso']
    }
    assert_equal out, expected
  end

  # cenario 2
  def test_supply_non_additive
    @app.supply(<<~JSON
      {
        "caixa": {
      	"caixaDisponivel": false,
      	"notas": {
      	  "notasDez": 100,
      	  "notasVinte": 50,
      	  "notasCinquenta": 10,
      	  "notasCem": 30
      	 }
        }
      }
    JSON
               )

    out = @app.supply(<<~JSON
      {
        "caixa": {
             "caixaDisponivel": true,
             "notas": {
             "notasDez": 350,
             "notasVinte": 1500,
             "notasCinquenta": 2500,
             "notasCem": 100
          }
        }
      }
    JSON
                     )

    expected = {
      caixa: {
        'caixaDisponivel': true,
        notas: {
          'notasDez': 350,
          'notasVinte': 1500,
          'notasCinquenta': 2500,
          'notasCem': 100
        }
      },
      errors: []
    }
    assert_equal out, expected
  end

  # cenario saque 1
  def test_withdraw
    @app.supply(<<~JSON
      {
        "caixa": {
      	"caixaDisponivel": true,
      	"notas": {
      	  "notasDez": 100,
      	  "notasVinte": 50,
      	  "notasCinquenta": 10,
      	  "notasCem": 30
      	 }
        }
      }
    JSON
               )

    out = @app.withdraw(
      <<~JSON
        {
          "saque":{
            "valor":80,
            "horario":"2019-02-13T11:01:01.000Z"
         }
        }
      JSON
    )

    expected = {
      caixa: {
        'caixaDisponivel': true,
        notas: {
          'notasDez': 99,
          'notasVinte': 49,
          'notasCinquenta': 9,
          'notasCem': 30
        }
      },
      errors: []
    }

    assert_equal out, expected
  end

  # cenario saque 2 - caixa inexistente
  def test_not_initialized
    out = @app.withdraw(
      <<~JSON
        {
          "saque": {
            "valor":80,
            "horario":"2019-02-13T11:01:01.000Z"
          }
        }
      JSON
    )

    expected = {
      caixa: {},
      errors: ['caixa-inexistente']
    }

    assert_equal out, expected
  end

  # cenario saque 3 - saque em caixa sem quantidade de dinheiro disponivel
  def test_withdraw_not_enough_cash
    @app.supply(<<~JSON
      {
        "caixa": {
          "caixaDisponivel": true,
          "notas": {
            "notasDez": 0,
            "notasVinte": 0,
            "notasCinquenta": 1,
            "notasCem": 3
          }
        }
      }
    JSON
               )

    out = @app.withdraw(
      <<~JSON
        {
          "saque": {
            "valor":600,
            "horario":"2019-02-13T11:01:01.000Z"
          }
        }
      JSON
    )

    expected = {
      caixa: {
        'caixaDisponivel': true,
        notas: {
          'notasDez': 0,
          'notasVinte': 0,
          'notasCinquenta': 1,
          'notasCem': 3
        }
      },
      errors: ['valor-indisponivel']
    }

    assert_equal out, expected
  end

  def test_reset_and_state
    @app.supply(<<~JSON
      {
        "caixa": {
          "caixaDisponivel": true,
          "notas": {
            "notasDez": 0,
            "notasVinte": 0,
            "notasCinquenta": 1,
            "notasCem": 3
          }
        }
      }
    JSON
               )

    @app.reset
    out = @app.state

    assert_equal out, { caixa: {}, errors: [] }
  end
end
