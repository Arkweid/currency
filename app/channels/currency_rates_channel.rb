# frozen_string_literal: true

class CurrencyRatesChannel < ApplicationCable::Channel
  CHANNEL = 'currency_rates_channel'

  def subscribed
    stream_from CHANNEL
  end
end
