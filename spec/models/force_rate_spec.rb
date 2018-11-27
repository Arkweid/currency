# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForceRate do
  include_context 'active_job_helper'

  let(:rate) { '123' }
  let(:valute) { 'USD' }
  let(:expired_at) { 1.day.from_now }

  subject { described_class.new(rate: rate, valute: valute, expired_at: expired_at) }

  it { should validate_presence_of(:rate) }
  it { should validate_numericality_of(:rate) }
  it { should validate_presence_of(:valute) }
  it { should validate_presence_of(:expired_at) }

  context '#broadcast_rate' do
    let(:jobs) { enqueued_jobs.select { |job| job[:job] == RateBroadcastJob } }

    before do
      subject.broadcast_rate
    end

    it 'enqueue hubspot create contact job' do
      expect(jobs.size).to eq 1
    end
  end

  context 'validate timeliness' do
    context 'too long ago' do
      let(:expired_at) { 1.second.ago }

      it { expect(subject.valid?).to eq false }
    end
    context 'too long future' do
      let(:expired_at) { 2.days.from_now + 1.second }

      it { expect(subject.valid?).to eq false }
    end

    context 'valid time' do
      it { expect(subject.valid?).to eq true }
    end
  end

  context '.get!' do
    context 'not expired rate' do
      before do
        subject.save!
      end

      it 'return rate' do
        expect(described_class.get!(valute)).to eq rate
      end
    end

    context 'expired rate' do
      before do
        subject.save!
        allow(DateTime).to receive(:current).and_return(3.days.from_now)
        described_class.get!(valute)
      end

      it 'return nil' do
        expect(described_class.get!(valute)).to eq nil
      end

      it 'destroy expired force rate' do
        expect(described_class.count).to eq 0
      end
    end
  end
end
