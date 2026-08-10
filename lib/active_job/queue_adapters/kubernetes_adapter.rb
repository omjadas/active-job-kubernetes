# frozen_string_literal: true

require 'active_job'
require 'active_job_kubernetes'

module ActiveJob
  module QueueAdapters
    class KubernetesAdapter < (const_defined?(:AbstractAdapter) ? AbstractAdapter : Object)
      def enqueue(job)
        ActiveJobKubernetes.create_job(job)
      end

      def enqueue_at(job, timestamp)
        ActiveJobKubernetes.create_job(job, timestamp)
      end
    end
  end
end
