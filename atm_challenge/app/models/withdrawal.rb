# frozen_string_literal: true

class Withdrawal
  def self.create(atm:, withdrawal:)
    @@store[atm.object_id].unshift(withdrawal)
  end

  def self.clear
    @@store = Hash.new([])
  end

  def self.most_recent(atm:)
    @@store[atm.object_id].first
  end

  def self.count
    @@store.size
  end

  def self.all(atm:)
    [*@@store[atm.object_id]]
  end

  def self.duplicate_withdrawal?(atm:, withdrawal:)
    amount = withdrawal[:amount]
    curr_time = withdrawal[:datetime]

    ten_minutes_in_seconds = 600.0

    @@store[atm.object_id].each do |prev|
      # We're going from latest to oldest transactions.
      # We break if the latest transaction is older than 10 minutes
      break if curr_time - prev[:datetime] >= ten_minutes_in_seconds

      return true if ((curr_time - prev[:datetime]) < ten_minutes_in_seconds) && (amount == prev[:amount])
    end

    false
  end

  @@store = Hash.new([])
end
