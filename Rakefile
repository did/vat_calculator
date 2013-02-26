require 'rubygems'
# require 'rake'
# require 'rdoc/task'

require 'rspec/core/rake_task'

desc 'Run specs'
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w{--colour --format progress}
    t.pattern = 'spec/*_spec.rb'
  end
end

task :default => [ :spec ]

# begin
#   puts "yeah"
#   require 'rspec/core/rake_task'
#   puts "wrong"

#   task :default => [ :spec ]
# rescue LoadError
#   puts "Unable to load rspec rake task"
# end