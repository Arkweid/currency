# frozen_string_literal: true

RSpec.shared_context 'active_job_helper', shared_context: :metadata do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'active_job_helper', include_shared: true
end
