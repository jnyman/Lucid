$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml'
require 'lucid/platform'
require 'lucid/runtime'
require 'lucid/cli/app'
require 'lucid/step_definitions'
require 'lucid/ansicolor'

module Lucid
  class << self
    attr_accessor :wants_to_quit
    attr_accessor :logger
  end
end
