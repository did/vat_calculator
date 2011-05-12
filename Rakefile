require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core/rake_task'

# desc 'Run specs'
# Spec::Rake::SpecTask.new do |t|
#   t.spec_files = Rake::FileList['spec/**/*_spec.rb']
#   t.spec_opts  = ['-c']
# end
#
# task :default => :spec


desc 'Run specs'
Rspec::Core::RakeTask.new('spec') do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec