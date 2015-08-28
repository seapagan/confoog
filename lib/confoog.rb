require 'confoog/version'

module Confoog

  DEFAULT_CONFIG = '.confoog'

  #Error messages to be returned
  ERR_NO_ERROR = 0
  ERR_FILE_NOT_EXIST = 1
  ERR_CANT_CHANGE = 2
  ERR_CANT_CREATE_FILE = 4

  #Info messages to be returned
  INFO_FILE_CREATED = 256

  class Settings
    attr_accessor :prefix
    attr_reader :filename, :location, :status

    def initialize(options = {})
      # default options to avoid ambiguity
      defaults = { create_file: false }
      defaults.merge!(options)
      # set all other unset options to return false instead of Nul.
      options.default = false
      @status = {}
      @location = options[:location] || '~/'
      @filename = options[:filename] || DEFAULT_CONFIG
      @prefix = options[:prefix] || 'Configuration :'

      @status['errors'] = ERR_NO_ERROR

      # make sure the file exists or can be created...
      check_exists(options)

    end

    def location=(location)
      # dummy method currently to stop changing location by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      @status['errors']= ERR_CANT_CHANGE
      console_output("Cannot change file location after creation")
    end

    def filename=(filename)
      # dummy method currently to stop changing filename by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      @status['errors']= ERR_CANT_CHANGE
      console_output("Cannot change filename after creation")
    end


    private

    def console_output(message)
      $stderr.puts "#{@prefix} #{message}"
    end

    def check_exists(options)
      if File.exist?(File.expand_path(File.join @location, @filename))
        @status['config_exists'] = true
      else
        if options[:create_file] == true
          full_path = File.expand_path(File.join @location, @filename)
          begin
            file = File.new(full_path, 'w').close
            @status['config_exists'] = true
            @status['errors'] = INFO_FILE_CREATED
          rescue => e
            @status['config_exists'] = false
            @status['errors'] = ERR_CANT_CREATE_FILE
            console_output("Cannot create the specified Configuration file!")
          end
        else
          @status['config_exists'] = false
          @status['errors'] = ERR_FILE_NOT_EXIST
          console_output("The specified Configuration file does not exist.")
        end
      end
    end
  end
end
