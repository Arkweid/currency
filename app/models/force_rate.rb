# frozen_string_literal: true

class ForceRate < ApplicationRecord
  enum valute: { USD: 0 }, _prefix: true

  validates :rate, presence: true, numericality: true
  validates :valute, presence: true
  validates :expired_at, presence: true,
                         timeliness: {
                           on_or_after: -> { DateTime.current }, # rubocop:disable Style/DateTime
                           before: -> { 2.days.from_now }
                         }

  after_commit :broadcast_rate

  def self.get!(valute)
    return unless (forced_rate = find_by(valute: valute))

    if DateTime.current > forced_rate.expired_at # rubocop:disable Style/DateTime
      forced_rate.destroy
      nil
    else
      forced_rate.rate
    end
  end

  def broadcast_rate
    RateBroadcastJob.perform_later
  end
end
