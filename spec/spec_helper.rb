$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require(:test)

require 'mocha'
require 'rspec'
require 'vat_calculator'

Rspec.configure do |config|
  config.mock_with :mocha
end