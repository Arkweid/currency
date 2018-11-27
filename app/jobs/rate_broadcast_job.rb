# frozen_string_literal: true

class RateBroadcastJob < ApplicationJob
  CHANNEL = CurrencyRatesChannel::CHANNEL
  USD = 'USD'

  def perform
    ActionCable.server.broadcast CHANNEL, usd: usd
  end

  private

  def usd
    Operations::Rates::Take.new.call(**rate_take_opts).value_or('unknown')
  end

  def rate_take_opts
    { valute: USD, rates_service: ApiClient::Cbr.new }
  end
end
