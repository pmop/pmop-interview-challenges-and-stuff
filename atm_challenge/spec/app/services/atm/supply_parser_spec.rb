RSpec.describe Services::Atm::SupplyParser do
  subject { ::Services::Atm::SupplyParser.new(json_string: json_string) }

  context 'parsing a supply json' do
    let(:json_string) do
      <<~JSON
       {
         "caixa":{
           "caixaDisponivel":true,
           "notas":{
             "notasDez":100,
             "notasVinte":50,
             "notasCinquenta":10,
             "notasCem":30
           }
         }
       }
      JSON
    end

    let(:expected_hash) do
        {
          available: true,
          bills: {
            10  => 100,
            20  => 50,
            50  => 10,
            100 => 30,
          }
        }
    end

    it 'returns the correct hash' do
      expect(subject.call).to eq expected_hash
    end
  end
end

