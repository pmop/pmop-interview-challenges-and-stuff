RSpec.describe ::Services::Atm::Withdraw do
  subject { ::Services::Atm::Withdraw.new(atm:, input: withdraw) }
  let(:time_anchor) { Time.parse('2019-02-13T11:01:01.000Z') }

  after(:each) do
    Withdrawal.clear
  end

  context 'Withdraw from Atm' do
    let(:atm) do
      state = {
        available: true,
        bills: {
          10  => 100,
          20  => 50,
          50  => 10,
          100 => 30,
        }
      }
      Atm.new(state)
    end

    let(:withdraw) do
      {
        amount: 80,
        datetime: time_anchor,
      }
    end

    before do
      Withdrawal.create(
        atm:,
        withdrawal: { amount: 100,  datetime: time_anchor - 60 }
      )
    end

    it 'Withdraws from the Atm correctly, returns Atm with the correct state, creates Withdrawal' do
      result = subject.call

      expect(result.state).to eq(
        {
          available: true,
          bills: {
            10  => 99,
            20  => 49,
            50  => 9,
            100 => 30,
          }
        }
      )

      expect(Withdrawal.all(atm:).size).to eq 2
      expect(Withdrawal.most_recent(atm:)).to eq(withdraw)
    end
  end

  context 'Errors' do
    let(:withdraw) { { amount: double(Integer), datetime: double(Time) } }

    context 'Atm not initialized' do
      let(:atm) { Atm.new }


      it 'raises the correct error' do
        expect { subject.call }.to raise_error(AtmNotIntialized)
      end
    end

    context 'Atm not available' do
      let(:atm) { Atm.new(available: false, bills: double(Hash)) }

      it 'raises the correct error' do
        expect { subject.call }.to raise_error(AtmNotAvailable)
      end
    end

    context 'Not Enough Cash' do
      let(:atm) do
        state = {
          available: true,
          bills: { # 180 total
            10  => 1,
            20  => 1,
            50  => 1,
            100 => 1,
          }
        }
        Atm.new(state)
      end

      let(:withdraw) { { amount: 190, datetime: double(Time) } }

      it 'raises the correct error' do
        expect { subject.call }.to raise_error(AtmNotEnoughCash)
      end
    end

    context 'Not Change Possible' do
      let(:atm) do
        state = {
          available: true,
          bills: { # 180 total
            10  => 1,
            20  => 1,
            50  => 1,
            100 => 1,
          }
        }
        Atm.new(state)
      end

      let(:withdraw) { { amount: 140, datetime: time_anchor } }

      it 'raises the correct error' do
        expect { subject.call }.to raise_error(AtmNotEnoughCash)
      end
    end

    context 'Duplicate Transaction' do
      let(:atm) do
        Atm.new(
          available: true,
          bills: {
            10  => 100,
            20  => 50,
            50  => 10,
            100 => 30,
          }
        )
      end

      before do
        Withdrawal.create(
          atm:,
          withdrawal: {
            amount: 80,
            datetime: Time.parse('2019-02-13T10:59:00.000Z')
          }
        )
        Withdrawal.create(
          atm:,
          withdrawal: {
            amount: 10,
            datetime: Time.parse('2019-02-13T11:01:01.000Z')
          }
        )
        Withdrawal.create(
          atm:,
          withdrawal: {
            amount: 80,
            datetime: Time.parse('2019-02-13T11:01:02.000Z')
          }
        )
      end

      after do
        Withdrawal.clear
      end

      context 'withdraw same value after less than 10 minutes' do
        let(:withdraw) do
          {
            amount: 80,
            datetime: Time.parse('2019-02-13T11:05:01.000Z')
          }
        end

        it 'raises the correct error' do
          expect { subject.call }.to raise_error(AtmDuplicatedWithdrawal)
        end
      end

      context 'withdraw same value after more than 10 minutes, after duplicate error' do
        let(:withdraw) do
          {
            amount: 80,
            datetime: Time.parse('2019-02-13T11:05:01.000Z')
          }
        end

        it 'raises the correct error' do
          expect { subject.call }.to raise_error(AtmDuplicatedWithdrawal)

          new_withdraw = withdraw.merge(datetime: Time.parse('2019-02-13T11:11:02.000Z'))

          expect { ::Services::Atm::Withdraw.new(atm:, input: new_withdraw).call }.not_to raise_error

          expect(Withdrawal.most_recent(atm:)).to eq new_withdraw
        end
      end
    end
  end
end
