# frozen_string_literal: true

require 'kubeclient'

module ActiveJob
  module QueueAdapters
    class KubernetesAdapter
      def enqueue(job)
        serialized_job = JSON.dump(job.serialize)
        kube_job = Kubeclient::Resource.new(job.manifest)

        kube_job.spec.template.spec.containers.map do |container|
          container.env ||= []
          container.env.push({
            'name' => 'SERIALIZED_JOB',
            'value' => serialized_job
          })
        end

        job.kubeclient('/apis/batch').create_job(kube_job)
      end

      def enqueue_at(_job, _timestamp)
        raise NotImplementedError, 'Enqueueing jobs in the future is not supported.'
      end
    end
  end
end
