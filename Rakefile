require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Run specs'
Rspec::Core::RakeTask.new('spec') do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec