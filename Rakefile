require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# RDoc
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.title    = "On"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main     = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end
