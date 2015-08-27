require 'confoog/version'

module Confoog

  DEFAULT_CONFIG = '.confoog'

  class Settings
    attr_reader :config_filename, :config_location, :status

    def initialize(options = {})
      # default options to avoid ambiguity
      defaults = { create_file: false }
      defaults.merge!(options)
      # set all other unset options to return false instead of Nul.
      options.default = false
      @status = {}
      @config_location = options[:location] || '~/'
      @config_filename = options[:filename] || DEFAULT_CONFIG

      # make sure the file exists or can be created...
      check_exists(options)
    end

    def config_location=(location)
      # dummy method currently to stop changing location by caller once created,
      # but not raise error.
      # In future will return an error flag in the ':status' variable.
    end

    def config_filename=(filename)
      # dummy method currently to stop changing filename by caller once creeated,
      # but not raise error.
      # In future will return an error flag in the ':status' variable.
    end

    private

    def check_exists(options)
      if File.exist?(File.expand_path(File.join @config_location, @config_filename))
        status['config_exists'] = true
      else
        if options[:create_file] == true
          full_path = File.expand_path(File.join @config_location, @config_filename)
          File.new(full_path, 'w').close
          if File.exist? full_path
            status['config_exists'] = true
          end
        else
          status['config_exists'] = false
        end
      end
    end
  end
end
