# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiClient::Cbr do
  failure = Dry::Monads::Result::Failure
  success = Dry::Monads::Result::Success

  subject { ApiClient::Cbr.new }

  context '#rates' do
    context 'valid xml response' do
      let(:valid_result) do
        {
          'AUD' => '48,2953', 'AZN' => '39,3634', 'GBP' => '85,1178', 'AMD' => '13,7549',
          'BYN' => '31,3521', 'BGN' => '38,6168', 'BRL' => '16,9449', 'HUF' => '23,2910',
          'HKD' => '85,3495', 'DKK' => '10,1232', 'USD' => '66,7800', 'EUR' => '75,6217',
          'INR' => '94,2455', 'KZT' => '17,9357', 'CAD' => '50,3354', 'KGS' => '95,6391',
          'CNY' => '96,1057', 'MDL' => '38,7692', 'NOK' => '77,5574', 'PLN' => '17,5908',
          'RON' => '16,2013', 'XDR' => '92,4516', 'SGD' => '48,5390', 'TJS' => '70,8917',
          'TRY' => '12,7489', 'TMT' => '19,1073', 'UZS' => '80,3127', 'UAH' => '23,7831',
          'CZK' => '29,1063', 'SEK' => '73,3379', 'CHF' => '66,8000', 'ZAR' => '48,1280',
          'KRW' => '59,0932', 'JPY' => '58,8007'
        }
      end

      it 'success' do
        expect(subject.rates).to eq success.new(valid_result)
      end
    end

    context 'invalid xml response' do
      let(:error) { "malformed XML: missing tag start\nLine: 1\nPosition: 53\nLast 80 unconsumed characters:\n<ValC" }

      before do
        WebMock.stub_request(:get, 'http://www.cbr.ru/scripts/XML_daily.asp')
               .to_return(status: 200, body: yaml_fixture_file('cbr_response.yml')['invalid_xml'], headers: {})
      end

      it 'failure' do
        expect(subject.rates).to eq failure.new(error)
      end
    end

    context 'invalid response code' do
      before do
        WebMock.stub_request(:get, 'http://www.cbr.ru/scripts/XML_daily.asp')
               .to_return(status: 400, body: '', headers: {})
      end

      it 'failure' do
        expect(subject.rates).to eq failure.new('ApiClient::Cbr have unexpected response')
      end
    end
  end
end
