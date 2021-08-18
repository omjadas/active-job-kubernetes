# frozen_string_literal: true

require 'kubeclient'

module ActiveJob
  module QueueAdapters
    class KubernetesJobAdapter
      def enqueue(job)
        kube_job = Kubeclient::Resource.new(job.manifest)
        job.kubeclient('/apis/batch').create_job(kube_job)
      end

      def enqueue_at(_job, _timestamp)
        raise NotImplementedError, 'Enqueueing jobs in the future is not supported.'
      end
    end
  end
end
