# frozen_string_literal: true

module ActiveJobKubernetes
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'active_job_kubernetes/tasks'
    end
  end
end
