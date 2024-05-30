RSpec.describe Services::Atm::WithdrawParser do
  subject { ::Services::Atm::WithdrawParser.new(json_string: json_string) }

  context 'parsing a withdraw json' do
    let(:json_string) do
      <<~JSON
      {
         "saque":{
            "valor":80,
            "horario":"2019-02-13T11:01:01.000Z"
        }
      }
      JSON
    end

    it 'returns the correct hash' do
      expect(subject.call).to match(
        {
          amount: 80,
          datetime: Time.parse("2019-02-13T11:01:01.000Z"),
        }
      )
    end
  end
end

