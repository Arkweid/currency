# frozen_string_literal: true

class RatesUpdateJob < ApplicationJob
  def perform
    Operations::Rates::Update.new.call(rates_service: ApiClient::Cbr.new).bind do
      RateBroadcastJob.perform_later
    end
  end
end
