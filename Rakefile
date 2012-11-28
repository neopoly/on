require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

namespace :test do
  desc "Run tests in isolation"
  task :isolation do
    FileList['test/*_test.rb'].each do |test_file|
      ruby "-Ilib:test #{test_file}"
    end
  end

  desc "Run tests with isolation tests"
  task :all => [ :test, :"test:isolation" ]
end

# RDoc
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.title    = "On"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main     = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end
