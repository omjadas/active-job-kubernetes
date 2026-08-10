# frozen_string_literal: true

require 'active_job/queue_adapters/kubernetes_adapter'
require 'active_job_kubernetes/railtie' if defined?(Rails::Railtie)
require 'active_job_kubernetes/version'
require 'json'
require 'kubeclient'
require 'time'

module ActiveJobKubernetes
  BATCH_API = '/apis/batch'
  CHUNK_SIZE = 100
  SERIALIZED_JOB = 'SERIALIZED_JOB'
  SERVICE_ACCOUNT = '/var/run/secrets/kubernetes.io/serviceaccount'
  SUSPEND = 'active-job-kubernetes/suspend'
  SUSPEND_UNTIL = 'active-job-kubernetes/suspend-until'

  private_constant :BATCH_API, :CHUNK_SIZE, :SERVICE_ACCOUNT

  class << self
    attr_writer :kubeclient, :namespace

    def kubeclient
      @kubeclient ||= lambda do |scope|
        Kubeclient::Client.new(
          "https://kubernetes.default.svc#{scope}",
          'v1',
          auth_options: { bearer_token_file: "#{SERVICE_ACCOUNT}/token" },
          ssl_options: { ca_file: "#{SERVICE_ACCOUNT}/ca.crt" }
        )
      end
    end

    def namespace
      @namespace ||= File.read("#{SERVICE_ACCOUNT}/namespace")
    end

    def create_job(job, timestamp = nil)
      serialized_job = JSON.dump(job.serialize)
      kube_job = Kubeclient::Resource.new(job.manifest)
      kube_job.metadata.namespace ||= namespace

      kube_job.spec.template.spec.containers.each do |container|
        container.env ||= []
        container.env.push({
          'name' => SERIALIZED_JOB,
          'value' => serialized_job
        })
      end

      if timestamp
        kube_job.spec.suspend = true

        kube_job.metadata.labels ||= {}
        kube_job.metadata.labels[SUSPEND] = 'true'

        kube_job.metadata.annotations ||= {}
        kube_job.metadata.annotations[SUSPEND_UNTIL] = Time.at(timestamp).utc.iso8601
      end

      job.provider_job_id = kubeclient_for(job).create_job(kube_job).metadata.name
    end

    def unsuspend_jobs
      now = Time.now
      client = kubeclient.call(BATCH_API)
      continue = nil

      loop do
        kube_jobs = client.get_jobs(
          namespace: namespace,
          label_selector: "#{SUSPEND}=true",
          limit: CHUNK_SIZE,
          continue: continue
        )

        kube_jobs.each do |kube_job|
          suspend_until = kube_job.metadata.annotations&.[](SUSPEND_UNTIL)
          next unless suspend_until && Time.iso8601(suspend_until) <= now

          client.patch_job(
            kube_job.metadata.name,
            { metadata: { labels: { SUSPEND => 'false' } }, spec: { suspend: false } },
            namespace
          )
        end

        continue = kube_jobs.continue
        break if kube_jobs.last?
      end
    end

    private

    def kubeclient_for(job)
      return job.kubeclient(BATCH_API) if job.respond_to?(:kubeclient)

      kubeclient.call(BATCH_API)
    end
  end
end
