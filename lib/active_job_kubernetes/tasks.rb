# frozen_string_literal: true

namespace :active_job_kubernetes do
  task run_job: :environment do
    ActiveJob::Base.execute(JSON.parse(ENV['SERIALIZED_JOB']))
  end
end
