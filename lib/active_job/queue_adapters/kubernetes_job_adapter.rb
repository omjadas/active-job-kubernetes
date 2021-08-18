module ActiveJob
  module QueueAdapters
    class KubernetesJobAdapter
      def enqueue(job)
        # TODO: Implement
      end

      def enqueue_at(_job, _timestamp)
        raise NotImplementedError, "Enqueueing jobs in the future is not supported."
      end
    end
  end
end
