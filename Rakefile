require 'rake'

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')

task :default => [:spec]

desc "Run all module spec tests (Requires rspec-puppet gem)"
task :spec do
  system("rspec spec")
end

desc "Build package"
task :build do
  system("puppet-module build")
end

