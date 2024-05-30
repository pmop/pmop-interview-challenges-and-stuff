RSpec.describe Withdrawal do
  after(:each) { Withdrawal.clear }
  let!(:atm) { Atm.new }
  let(:withdrawal1) do
    { amount: 80, datetime: Time.parse('2019-02-13T11:00:00.000Z') }
  end

  let(:withdrawal2) do
    { amount: 40, datetime: Time.parse('2019-02-13T11:01:01.000Z') }
  end

  let(:ten_minutes_in_seconds) { 600.0 }

  describe '.create' do
    before do
      Withdrawal.create(atm: atm, withdrawal: withdrawal1)
    end

    it 'Creates a withdrawal for ATM withdrawals given the Atm object instance' do
      Withdrawal.create(atm: atm, withdrawal: withdrawal2)

      expect(Withdrawal.all(atm: atm)).to match_array([withdrawal2, withdrawal1])
    end
  end

  describe '.most_recent' do
    before do
      Withdrawal.create(atm: atm, withdrawal: withdrawal1)
      Withdrawal.create(atm: atm, withdrawal: withdrawal2)
    end

    it 'Returns the most recent withdrawal' do
      expect(Withdrawal.most_recent(atm: atm)).to eq(withdrawal2)
    end
  end

  describe '.duplicate_withdrawal?' do
    subject { ->(withdrawal) { Withdrawal.duplicate_withdrawal?(atm: atm, withdrawal: withdrawal) } }
    before(:each) do
      Withdrawal.create(atm: atm, withdrawal: withdrawal1)
      Withdrawal.create(atm: atm, withdrawal: withdrawal2)
      Withdrawal.create(
        atm: atm,
        withdrawal: {
          amount: 90,
          datetime: Time.parse('2019-02-13T11:02:01.000Z')
        }
      )
    end

    after(:each) { Withdrawal.clear }

    context 'withdraw same value after less than 10 minutes' do
      it 'returns true' do
        withdrawal40 = withdrawal2.merge(datetime: Time.parse('2019-02-13T11:09:01.000Z'))
        withdrawal80 = withdrawal1.merge(datetime: Time.parse('2019-02-13T11:09:00.000Z'))

        expect(subject.call(withdrawal40)).to be true
        expect(subject.call(withdrawal80)).to be true
      end
    end

    context 'withdraw same value after 10 minutes' do
      it 'returns true' do
        withdrawal40 = withdrawal2.merge(datetime: withdrawal2[:datetime] + ten_minutes_in_seconds)
        withdrawal80 = withdrawal1.merge(datetime: withdrawal1[:datetime] + ten_minutes_in_seconds)

        expect(subject.call(withdrawal40)).to be false
        expect(subject.call(withdrawal80)).to be false
      end
    end

    context 'withdraw same value after more than 10 minutes' do
      it 'returns true' do
        withdrawal40 = withdrawal2.merge(datetime: withdrawal2[:datetime] + ten_minutes_in_seconds + 1.0)
        withdrawal80 = withdrawal1.merge(datetime: withdrawal1[:datetime] + ten_minutes_in_seconds + 1.0)

        expect(subject.call(withdrawal40)).to be false
        expect(subject.call(withdrawal80)).to be false
      end
    end
  end
end
