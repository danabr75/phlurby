#!/usr/bin/env ruby
SCRIPT_DIRECTORY = File.expand_path('../../', __FILE__)
require "#{SCRIPT_DIRECTORY}/gosu-test/gosu-test.rb"
OpenGLIntegration.new.show if __FILE__ == $0