class ForceRate < ApplicationRecord
  validates :rate, presence: true, numericality: true
  validates :expired_at, presence: true, 
                         timeliness: {
                           on_or_after: -> { DateTime.current },
                           before: -> { 2.days.from_now }
                         }
  validate :single_record

  private

  def single_record
    errors.add(:base, :single_record) if self.class.count > 1
  end
end
