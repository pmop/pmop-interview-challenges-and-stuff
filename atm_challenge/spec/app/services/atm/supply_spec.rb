RSpec.describe ::Services::Atm::Supply do
  subject { ::Services::Atm::Supply.new(atm: atm, input: supply) }

  context 'Supplying Atm' do
    context 'Atm not in use' do
      let(:atm) do
        state = {
          available: false,
          bills: {
            10  => 1,
            20  => 1,
            50  => 1,
            100 => 1,
          }
        }
        Atm.new(state)
      end

      let(:supply) do
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

	  # teste no qual sucessivos abastecimentos são aditivos
      xit 'supplies the Atm correctly' do
        result = subject.call

        expect(result.state).to eq(
          {
            available: true,
            bills: {
              10  => 101,
              20  => 51,
              50  => 11,
              100 => 31,
            }
          }
        )
      end

      it 'supplies the Atm correctly' do
        result = subject.call

        expect(result.state).to eq(
          {
            available: true,
            bills: {
			  10  => 100,
			  20  => 50,
			  50  => 10,
			  100 => 30,
            }
          }
        )
      end
    end

    context 'Atm not initialized' do
      let(:atm) { Atm.new }

      let(:supply) do
        {
          available: false,
          bills: {
            10  => 100,
            20  => 50,
            50  => 10,
            100 => 30,
          }
        }
      end

      it 'supplies the Atm correctly' do
        result = subject.call

        expect(result.state).to eq supply
      end
    end


    context 'Atm in use' do
      let(:atm_state) do
        {
          available: true,
          bills: {
            10  => 1,
            20  => 5,
            50  => 1,
            100 => 3,
          }
        }
      end

      let(:atm) { Atm.new(atm_state) }

      let(:supply) do
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

      it 'raises Atm in use error, does not change the state' do
        expect { subject.call }.to raise_error(AtmInUseError)

        expect(atm.state).to eq(atm_state)
      end
    end
  end
end
