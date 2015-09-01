require 'confoog/version'
require 'yaml'

module Confoog
  DEFAULT_CONFIG = '.confoog'

  # Error messages to be returned
  ERR_NO_ERROR = 0
  ERR_FILE_NOT_EXIST = 1
  ERR_CANT_CHANGE = 2
  ERR_CANT_CREATE_FILE = 4
  ERR_NOT_WRITING_EMPTY_FILE = 8
  ERR_CANT_SAVE_CONFIGURATION = 16
  ERR_NOT_LOADING_EMPTY_FILE = 32

  # Info messages to be returned
  INFO_FILE_CREATED = 256
  INFO_FILE_LOADED = 512

  OUTPUT_SEVERITY = { ERR: 'Error', WARN: 'Warning', INFO: 'Information' }

  class Settings
    attr_accessor :prefix, :quiet
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
      @prefix = options[:prefix] || 'Configuration'
      @quiet = options[:quiet] || false

      @config = {}

      @status['errors'] = ERR_NO_ERROR

      # make sure the file exists or can be created...
      check_exists(options)
    end

    def save
      if @config.count > 0
        save_to_yaml
      else
        console_output("Not saving empty configuration data to #{config_path}",
                       OUTPUT_SEVERITY[:WARN])
        @status['errors'] = ERR_NOT_WRITING_EMPTY_FILE
      end
    end

    def load
      @config = YAML.load_file(config_path)
      if @config == false
        console_output("Configuration file #{config_path} is empty!",
                       OUTPUT_SEVERITY[:WARN])
        @status['errors'] = ERR_NOT_LOADING_EMPTY_FILE
      else
        @status['errors'] = INFO_FILE_LOADED
      end
    rescue
      console_output("Cannot load configuration data from #{config_path}",
                     OUTPUT_SEVERITY[:ERR])
    end

    def location=(*)
      # dummy method currently to stop changing location by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      @status['errors'] = ERR_CANT_CHANGE
      console_output('Cannot change file location after creation',
                     OUTPUT_SEVERITY[:WARN])
    end

    def filename=(*)
      # dummy method currently to stop changing filename by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      @status['errors'] = ERR_CANT_CHANGE
      console_output('Cannot change filename after creation',
                     OUTPUT_SEVERITY[:WARN])
    end

    def [](key)
      @config[key]
    end

    def []=(key, value)
      @config[key] = value
    end

    def config_path
      File.expand_path(File.join(@location, @filename))
    end

    private

    def console_output(message, severity)
      $stderr.puts "#{@prefix} : #{severity} - #{message}" unless @quiet == true
    end

    def save_to_yaml
      file = File.open(config_path, 'w')
      file.write(@config.to_yaml)
    rescue
      console_output("Cannot save configuration data to #{config_path}",
                     OUTPUT_SEVERITY[:ERR])
    end

    def check_exists(options)
      if File.exist?(config_path)
        @status['config_exists'] = true
      else
        if options[:create_file] == true
          begin
            File.new(config_path, 'w').close
            @status['config_exists'] = true
            @status['errors'] = INFO_FILE_CREATED
          rescue
            @status['config_exists'] = false
            @status['errors'] = ERR_CANT_CREATE_FILE
            console_output('Cannot create the specified Configuration file!',
                           OUTPUT_SEVERITY[:ERR])
          end
        else
          @status['config_exists'] = false
          @status['errors'] = ERR_FILE_NOT_EXIST
          console_output('The specified Configuration file does not exist.',
                         OUTPUT_SEVERITY[:ERR])
        end
      end
    end
  end
end
