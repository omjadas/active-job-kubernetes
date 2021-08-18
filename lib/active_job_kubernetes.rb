require "active_job_kubernetes/version"
require "active_job_kunernetes/railtie" if defined?(Rails::Railtie)

module ActiveJobKubernetes
  class Error < StandardError; end
  # Your code goes here...
end
