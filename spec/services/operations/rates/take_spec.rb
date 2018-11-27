# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::Rates::Take do
  let(:success) { Dry::Monads::Result::Success }
  let(:failure) { Dry::Monads::Result::Failure }
  let(:valute) { 'USD' }
  let(:rates_service) { ApiClient::Cbr.new }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  subject { described_class.new.call(valute: valute, rates_service: rates_service) }

  context '#call' do
    context 'forced_rate' do
      before { create(:force_rate) }

      it 'success' do
        expect(subject).to eq success.new('12345')
      end
    end

    context 'cached_rate' do
      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
        cache.write('rates', 'USD' => '999')
      end

      it 'success' do
        expect(subject).to eq success.new('999')
      end
    end

    context 'actual_rate' do
      it 'success' do
        expect(subject).to eq success.new('66,7800')
      end
    end

    context 'found nothing' do
      before do
        WebMock.stub_request(:get, 'http://www.cbr.ru/scripts/XML_daily.asp')
               .to_return(status: 400, body: '', headers: {})
      end

      it 'failure' do
        expect(subject).to eq failure.new(:not_found)
      end
    end
  end
end
