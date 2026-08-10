# Changelog

## 0.2.0

- Support Rails 7 and 8
- Require Ruby 2.7+
- Inherit from `ActiveJob::QueueAdapters::AbstractAdapter` where available
- Set `provider_job_id` for enqueued jobs
- Support delayed jobs by creating a suspended Kubernetes Job labelled
  `active-job-kubernetes/suspend` and annotated with
  `active-job-kubernetes/suspend-until`. `ActiveJobKubernetes.unsuspend_jobs`
  must be called periodically to unsuspend jobs that are ready to run

## 0.1.0

- Initial release
