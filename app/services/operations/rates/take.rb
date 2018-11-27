# frozen_string_literal: true

module Operations::Rates
  class Take
    include Dry::Monads::Result::Mixin

    attr_reader :valute, :rates_service

    def call(valute:, rates_service:)
      @valute = valute
      @rates_service = rates_service

      if (result = forced_rate || cached_rate || actual_rate)
        Success(result)
      else
        Failure(:not_found)
      end
    end

    private

    def forced_rate
      ForceRate.get!(valute)
    end

    def cached_rate
      @cached_rate ||= Rails.cache.read(CACHE_KEY)&.fetch(valute) { nil }
    end

    def actual_rate
      rates_service.rates.value_or({}).fetch(valute) { nil }
    end
  end
end
