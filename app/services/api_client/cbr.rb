# frozen_string_literal: true

require 'dry/monads/result'

module ApiClient
  class Cbr
    include Dry::Monads::Result::Mixin
    include Informer
    include ApiLogger

    class ApiClientCbrError < StandardError; end

    RATES_URI = URI('http://www.cbr.ru/scripts/XML_daily.asp')

    def rates
      response = Net::HTTP.get_response(RATES_URI)

      return Success(extract_valutes { Hash.from_xml(response.body) }) if response.is_a?(Net::HTTPSuccess)

      raise ApiClientCbrError, 'ApiClient::Cbr have unexpected response'
    rescue StandardError => e
      log(e)
      warning(e)
      Failure(e.message)
    end

    private

    def extract_valutes
      yield['ValCurs']['Valute'].map { |row| [row['CharCode'], row['Value']] }.to_h
    end

    def log_path
      'log/api_client_cbr.log'
    end
  end
end
