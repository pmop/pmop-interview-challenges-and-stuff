# frozen_string_literal: true

require 'zeitwerk'
require 'json'
require 'time'
require_relative '../lib/errors'

module AtmChallenge
  class Application # rubocop:disable Style/Documentation
    @@autoload_paths = ['app/models', 'app/', 'lib/'] # rubocop:disable Style/ClassVars

    def self.run(&block)
      autoload

      block.call
    end

    def self.autoload
      loader = Zeitwerk::Loader.new
      @@autoload_paths.each { |p| loader.push_dir(p) }
      loader.setup
    end
  end
end
