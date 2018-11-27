# frozen_string_literal: true

module Operations::Rates
  class Update
    include Dry::Monads::Result::Mixin
    include Dry::Transaction

    attr_reader :actual_rates

    step :get_actual_rates
    step :write_rates_to_cache

    private

    def get_actual_rates(input)
      @actual_rates = input[:rates_service].rates
    end

    def write_rates_to_cache(input)
      Rails.cache.write(CACHE_KEY, actual_rates.value!).present? ? Success(input) : Failure(:cache_not_written)
    end
  end
end
