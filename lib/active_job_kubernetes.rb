# frozen_string_literal: true

require 'active_job/queue_adapters/kubernetes_adapter'
require 'active_job_kubernetes/version'
require 'active_job_kubernetes/railtie' if defined?(Rails::Railtie)
