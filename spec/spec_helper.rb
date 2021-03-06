gem_path = File.dirname(__FILE__) + "/../lib"
$:.unshift(gem_path) unless $:.include?(gem_path)

require 'rspec/core'
require 'bowler'

require_relative 'helpers/definition_helper'
require_relative 'helpers/cli_helper'

Bowler::CLI.logger = Logger.new('/dev/null')

RSpec.configure do |config|
  config.mock_framework = :mocha
end
