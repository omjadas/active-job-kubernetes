# frozen_string_literal: true

require 'active_job'
require 'json'
require 'kubeclient'

module ActiveJob
  module QueueAdapters
    class KubernetesAdapter < (const_defined?(:AbstractAdapter) ? AbstractAdapter : Object)
      SERIALIZED_JOB = 'SERIALIZED_JOB'

      def enqueue(job)
        serialized_job = JSON.dump(job.serialize)
        kube_job = Kubeclient::Resource.new(job.manifest)

        kube_job.spec.template.spec.containers.each do |container|
          container.env ||= []
          container.env.push({
            'name' => SERIALIZED_JOB,
            'value' => serialized_job
          })
        end

        job.provider_job_id = job.kubeclient('/apis/batch').create_job(kube_job).metadata.name
      end

      def enqueue_at(_job, _timestamp)
        raise NotImplementedError, 'Enqueueing jobs in the future is not supported.'
      end
    end
  end
end
