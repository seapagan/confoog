require 'confoog/version'
require 'yaml'

# rubocop:disable LineLength

# Overall module.
# Contains Class Confoog::Settings
module Confoog
  # The default filename used if none specified when created.
  DEFAULT_CONFIG = '.confoog'

  # Error messages to be returned

  # No error condition exists
  ERR_NO_ERROR = 0
  # The specified file does not exist
  ERR_FILE_NOT_EXIST = 1
  # You cannot change location or filename after class is instantiated
  ERR_CANT_CHANGE = 2
  # Was unable to create the specified file
  ERR_CANT_CREATE_FILE = 4
  # There are no configuration variables set, so not writing empty file
  ERR_NOT_WRITING_EMPTY_FILE = 8
  # Cannot save to the specified file for some reason
  ERR_CANT_SAVE_CONFIGURATION = 16
  # The specified file is empty so not trying to load settings from it
  ERR_NOT_LOADING_EMPTY_FILE = 32

  # Info messages to be returned

  # Information - file was created successfully
  INFO_FILE_CREATED = 256
  # Information - configuration was successfully loaded
  INFO_FILE_LOADED = 512

  # Hash containing text versions of the assorted error severity.
  OUTPUT_SEVERITY = {
    ERR: 'Error',
    WARN: 'Warning',
    INFO: 'Information'
  }

  # Hash containing default values of initialization variables
  DEFAULT_OPTIONS = {
    create_file: false,
    quiet: false,
    prefix: 'Configuration',
    location: '~/',
    filename: DEFAULT_CONFIG,
    auto_load: false
  }

  # Provide an encapsulated class to access a YAML configuration file.
  # @!attribute [r] filename
  #   @return [String] The configuration filename in use.
  # @!attribute [r] location
  #   @return [String] The directory storing the configuration file.
  # @!attribute [r] status
  #   @return [Hash] A hash containing status variables.
  # @example
  #   require 'confoog'
  #   settings = Confoog::Settings.new
  #   settings[:var] = value
  #   settings[:array] = [1, 2, 3, 4]
  #   settings[42] = "Meaning of life"
  #   settings[:urls] = ["https://www.mywebsite.com", "https://www.anothersite.com/a/page.html"]
  #
  #   settings[:urls].each do |url|
  #     puts url
  #   end
  #   # https://www.mywebsite.com
  #   # https://www.anothersite.com/a/page.html
  #   # => ["https://www.mywebsite.com", "https://www.anothersite.com/a/page.html"]
  #
  #   settings[:dont_exist]
  #   # => nil
  #
  #   a_variable = 50
  #   settings[a_variable] = {:one => "for the money", :two => "for the show", :three => "to get ready"}
  #   settings[50]
  #   # => {:one => "for the money", :two => "for the show", :three => "to get ready"}
  #   settings[50][:two]
  #   # => "for the show"
  class Settings
    attr_reader :filename, :location, :status

    # rubocop:enable LineLength

    # Setup the class with specified parameters or default values if any or all
    # are absent.
    # All parameters are optional.
    # @param options [Hash] Hash value containing any passed parameters.
    def initialize(options = {})
      # merge default options to avoid ambiguity
      @options = DEFAULT_OPTIONS.merge(options)
      # set all other unset options to return false instead of Nul.
      @options.default = false

      # Hash containing any error or return from methods
      @status = {}
      @location = @options[:location]
      @filename = @options[:filename]

      @config = {}

      # clear the error condition as default.
      status_set(errors: ERR_NO_ERROR)
      # make sure the file exists or can be created...
      check_exists(options)

      # if auto_load is true, automatically load from file
      load unless @options[:auto_load] == false
    end

    # Return the value of the 'quiet' option.
    # @example
    #   is_quiet = settings.quiet
    # @param [None]
    # @return [Boolean] True if we are not writing to the console on error
    def quiet
      @options[:quiet]
    end

    # Change the 'quiet' option.
    # @example
    #   settings.quiet = true
    # @return [Boolean] The new value [true | false]
    # @param quiet [Boolean] True to send messages to console for errors.
    def quiet=(quiet)
      @options[:quiet] = quiet
    end

    # Save the entire configuration (@config) to the YAML file.
    # @example
    #   settings.save
    # @param [None]
    # @return Unspecified
    def save
      if @config.count > 0
        save_to_yaml
      else
        console_output("Not saving empty configuration data to #{config_path}",
                       OUTPUT_SEVERITY[:WARN])
        status_set(errors: ERR_NOT_WRITING_EMPTY_FILE)
      end
    end

    # Populate the configuration (@config) from the YAML file.
    # @param [None]
    # @example
    #   settings.load
    # @return Unspecified
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

    # dummy method currently to stop changing location by caller once created,
    # @return [hash] an error flag in the ':status' variable.
    # @param [Optional] Parameter is ignored
    def location=(*)
      status_set(errors: ERR_CANT_CHANGE)
      console_output('Cannot change file location after creation',
                     OUTPUT_SEVERITY[:WARN])
    end

    # dummy method currently to stop changing filename by caller once created,
    # @return [hash] an error flag in the ':status' variable.
    # @param optional Parameter is ignored
    def filename=(*)
      status_set(errors: ERR_CANT_CHANGE)
      console_output('Cannot change filename after creation',
                     OUTPUT_SEVERITY[:WARN])
    end

    # Read the configuration key (key)
    # @example
    #   key = settings[:key]
    # @return [<various>] Return value depends on the type of variable stored
    def [](key)
      @config[key]
    end

    # Set a configuration key
    # @example
    #   settings[:key] = "Value"
    #   settings[:array] = ["first", "second", "third"]
    # @return [<various>] Returns the variable that was assigned.
    def []=(key, value)
      @config[key] = value
    end

    # Returns the fully qualified path to the configuration file in use.
    # @example
    #   path = config_path
    # @return [String] Full path and filename of the configuration file.
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
      file.close
    rescue
      status_set(errors: ERR_CANT_SAVE_CONFIGURATION)
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
