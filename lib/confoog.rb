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

  OUTPUT_SEVERITY = {
    ERR: 'Error',
    WARN: 'Warning',
    INFO: 'Information'
  }

  DEFAULT_OPTIONS = {
    create_file: false,
    quiet: false,
    prefix: 'Configuration'
  }

  class Settings
    attr_reader :filename, :location, :status

    def initialize(options = {})
      # merge default options to avoid ambiguity
      @options = DEFAULT_OPTIONS.merge(options)
      # set all other unset options to return false instead of Nul.
      @options.default = false

      @status = {}
      @location = @options[:location] || '~/'
      @filename = @options[:filename] || DEFAULT_CONFIG

      @config = {}

      # clear the error condition as default.
      status_set(errors: ERR_NO_ERROR)
      # make sure the file exists or can be created...
      check_exists(options)
    end

    def quiet
      @options[:quiet]
    end

    def quiet=(quiet)
      @options[:quiet] = quiet
    end

    def save
      if @config.count > 0
        save_to_yaml
      else
        console_output("Not saving empty configuration data to #{config_path}",
                       OUTPUT_SEVERITY[:WARN])
        status_set(errors: ERR_NOT_WRITING_EMPTY_FILE)
      end
    end

    def load
      @config = YAML.load_file(config_path)
      status_set(errors: INFO_FILE_LOADED)
      if @config == false
        console_output("Configuration file #{config_path} is empty!",
                       OUTPUT_SEVERITY[:WARN])
        status_set(errors: ERR_NOT_LOADING_EMPTY_FILE)
      end
    rescue
      console_output("Cannot load configuration data from #{config_path}",
                     OUTPUT_SEVERITY[:ERR])
    end

    def location=(*)
      # dummy method currently to stop changing location by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      status_set(errors: ERR_CANT_CHANGE)
      console_output('Cannot change file location after creation',
                     OUTPUT_SEVERITY[:WARN])
    end

    def filename=(*)
      # dummy method currently to stop changing filename by caller once created,
      # but not raise error.
      #  - Return an error flag in the ':status' variable.
      status_set(errors: ERR_CANT_CHANGE)
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
      return unless @options[:quiet] == false
      $stderr.puts "#{@options[:prefix]} : #{severity} - #{message}"
    end

    def save_to_yaml
      file = File.open(config_path, 'w')
      file.write(@config.to_yaml)
    rescue
      console_output("Cannot save configuration data to #{config_path}",
                     OUTPUT_SEVERITY[:ERR])
    end

    def create_new_file
      File.new(config_path, 'w').close
      status_set(config_exists: true, errors: INFO_FILE_CREATED)
    rescue
      status_set(config_exists: false, errors: ERR_CANT_CREATE_FILE)
      console_output('Cannot create the specified Configuration file!',
                     OUTPUT_SEVERITY[:ERR])
    end

    def status_set(status)
      status.each do |key, value|
        @status[key] = value
      end
    end

    def check_exists(options)
      status_set(config_exists: true)
      return if File.exist?(config_path)

      # file does not exist so we create if requested otherwise error out
      if options[:create_file] == true
        create_new_file
      else
        status_set(config_exists: false, errors: ERR_FILE_NOT_EXIST)
        console_output('The specified Configuration file does not exist.',
                       OUTPUT_SEVERITY[:ERR])
      end
    end
  end
end
