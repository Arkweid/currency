# frozen_string_literal: true

FactoryBot.define do
  factory :force_rate do
    rate { 12_345 }
    valute { 'USD' }
    expired_at { 1.day.from_now }
  end
end
