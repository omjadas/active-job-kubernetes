# frozen_string_literal: true

require_relative 'lib/active_job_kubernetes/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_job_kubernetes'
  spec.version       = ActiveJobKubernetes::VERSION
  spec.authors       = ['omjadas']
  spec.email         = ['omja.das@gmail.com']

  spec.summary       = 'Active Job Adapter for Kubernetes'
  spec.description   = 'Run Rails Active Jobs as Kubernetes Jobs'
  spec.homepage      = 'https://github.com/omjadas/active-job-kubernetes'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/omjadas/active-job-kubernetes'
  spec.metadata['changelog_uri'] = 'https://github.com/omjadas/active-job-kubernetes/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'kubeclient', '~> 4.0'
  spec.add_dependency 'rails', '>= 5.0', '<7'
end
