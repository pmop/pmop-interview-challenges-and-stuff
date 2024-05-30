require 'change_making'

RSpec.describe ChangeMaking do
  subject { ChangeMaking.new(amount: amount, limits: limits) }

  context 'solve for amount=30, enough limits' do
    let(:limits) { { 10 => 100, 20 => 50, 50 => 10, 100 => 30 } }
    let(:amount) { 30 }

    it 'returns the correct hash' do
      result = subject.call
      expect(result).to match({ 20 => 1, 10 => 1 })
    end
  end
end

