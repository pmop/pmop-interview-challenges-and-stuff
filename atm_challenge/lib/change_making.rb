# Solve Change-Making problem for average cases with greedy solution
class ChangeMaking
  # @param amount [Integer] the amount to change
  # @param limits [Hash<Integer, Integer>] the hash with limits key pair of the nominal
  # and the amount of that nominal
  def initialize(amount:, limits:)
    @amount = amount
    @limits = limits
  end

  def call
    greedy
  end

  private

  # Greedy solution for Change-Making problem
  def greedy
    recurring = lambda do |amount, nominals|
      return {} if amount == 0
      return nil if nominals.empty?

      nominal = nominals.first
      count = [limits[nominal], amount/nominal].min

      count.downto(0).each do |index|
        result = recurring.call(amount - index * nominal, nominals.drop(1))

        return result ? (!index.zero? ? { nominal => index }.merge(result) : result) : nil
      end
    end

    nominals = limits.keys.sort { |a, b| b <=> a }

    recurring.call(amount, nominals)
  end

  attr_reader :amount, :limits
end
