# frozen_string_literal: true

class HomeController < ApplicationController
  USD = 'USD'

  def index
    @usd_rate = Operations::Rates::Take.new.call(**rate_take_opts).value_or('unknown')
  end

  private

  def rate_take_opts
    { valute: USD, rates_service: ApiClient::Cbr.new }
  end
end
