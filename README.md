# active-job-kubernetes
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fomjadas%2Factive-job-kubernetes.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fomjadas%2Factive-job-kubernetes?ref=badge_shield)


Rails Active Job adapter to run background jobs using
[Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_job_kubernetes'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install active-job-kubernetes
```

## Usage

```ruby
class HelloWorldJob < ApplicationJob
  self.queue_adapter = :kubernetes

  def perform
    puts 'Hello, world'
  end

  def manifest
    YAML.safe_load(
      <<~MANIFEST
        apiVersion: batch/v1
        kind: Job
        metadata:
          generatedName: hello-world
        spec:
          template:
            metadata:
              name: hello-world
            spec:
              restartPolicy: Never
              containers:
                - name: worker
                  image: example:latest
                  command: ["rake"]
                  args: ["active_job_kubernetes:run_job"]
      MANIFEST
    )
  end

  def kubeclient(scope)
    endpoint = '' # cluster endpoint

    Kubeclient::Client.new(endpoint + scope, 'v1')
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/omjadas/active-job-kubernetes>.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fomjadas%2Factive-job-kubernetes.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fomjadas%2Factive-job-kubernetes?ref=badge_large)