require 'formatter'

RSpec.describe Formatter do

  describe '.format_for_output' do
    let(:atm) do
      Atm.new(
        available: false,
        bills: {
          10  => 100,
          20  => 50,
          50  => 10,
          100 => 30,
        }
      )
    end

    it 'formats correctly' do
      expect(Formatter.format_for_output(atm)).to eq(
        caixa: {
          :'caixaDisponivel' => false,
          notas: {
            :'notasDez' =>      100,
            :'notasVinte' =>     50,
            :'notasCinquenta' => 10,
            :'notasCem' =>       30,
          },
        }
      )
    end
  end
end

