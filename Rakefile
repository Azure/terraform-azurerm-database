# Official gems.
require 'colorize'
require 'rspec/core/rake_task'

# Git repo gems.
require 'bundler/setup'
require 'terramodtest'

namespace :static do
  task :style do
    style_tf
  end
  task :lint do
    lint_tf
  end
  task :format do
    format_tf
  end
  task :test do
    success = system ("go test -v terratest/sql/terraform_database_example_test.go terratest/sql/database_functions.go")
    if not success 
      raise "ERROR: Go test failed!\n".red
    end
  end
end

task :prereqs => []

task :validate => [ 'static:style', 'static:lint', 'static:test']

task :format => [ 'static:format' ]

task :build => [ 'prereqs', 'validate' ]

task :unit => []

task :e2e => []

task :default => [ 'build' ]

task :full => [ 'build', 'unit', 'e2e']
