require "confoog/version"

module Confoog

  DEFAULT_CONFIG = '.confoog'

  class Settings

    attr_accessor :config_filename, :config_location

    def initialize(options = {})
      @config_location = options[:location] || '~/'
      @config_filename = options[:filename] || DEFAULT_CONFIG
    end
  end
end
