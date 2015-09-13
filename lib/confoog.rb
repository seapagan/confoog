require 'confoog/version'
require 'confoog/status'
require 'yaml'

# rubocop:disable LineLength

# Overall module.
# Contains Class Confoog::Settings
module Confoog
  # The default filename used if none specified when created.
  DEFAULT_CONFIG = '.confoog'

  # Hash containing default values of initialization variables
  DEFAULT_OPTIONS = {
    create_file: false,
    quiet: false,
    prefix: 'Configuration',
    location: '~/',
    filename: DEFAULT_CONFIG,
    autoload: false,
    autosave: true
  }

  # Provide an encapsulated class to access a YAML configuration file.
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
    attr_reader :status

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
      @status = Status.new(@options[:quiet], @options[:prefix])
      # clear the error condition as default.
      @status.clear_error

      # Initialize the Configuration to and empty hash.
      @config = {}

      # make sure the file exists or can be created...
      check_exists(options)

      # if auto_load is true, automatically load from file
      load unless @options[:autoload] == false
    end

    # Return the value of the 'autosave' option.
    # @example
    #   autosave_status = settings.autosave
    #   => true
    # @param [None]
    # @return [Boolen] true if we are autosaving on change or addition.
    def autosave
      @options[:autosave]
    end

    # Change the 'autosave' option.
    # @example
    #   settings.autosave = false
    #   => false
    # @return [Boolean] The new value [true | false]
    # @param autosave [Boolean] True to send messages to console for errors.
    def autosave=(autosave)
      @options[:autosave] = autosave
    end

    # Return the value of the 'quiet' option.
    # @example
    #   is_quiet = settings.quiet
    # @param [None]
    # @return [Boolean] True if we are not writing to the console on error
    def quiet
      @status.quiet
    end

    # Change the 'quiet' option.
    # @example
    #   settings.quiet = true
    # @return [Boolean] The new value [true | false]
    # @param quiet [Boolean] True to send messages to console for errors.
    def quiet=(quiet)
      @status.quiet = quiet
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
        @status.set(errors: Status::ERR_NOT_WRITING_EMPTY_FILE)
      end
    end

    # Populate the configuration (@config) from the YAML file.
    # @param [None]
    # @example
    #   settings.load
    # @return Unspecified
    def load
      @config = YAML.load_file(config_path)
      @status.set(errors: Status::INFO_FILE_LOADED)
      if @config == false
        @status.set(errors: Status::ERR_NOT_LOADING_EMPTY_FILE)
      end
    rescue
      @status.set(errors: Status::ERR_CANT_LOAD)
    end

    # Read the configuration key (key)
    # @example
    #   key = settings[:key]
    # @return [<various>] Return value depends on the type of variable stored
    def [](key)
      @config[key]
    end

    # Set a configuration key.
    # If autosave: true then will also update the config file (default is true)
    # @example
    #   settings[:key] = "Value"
    #   settings[:array] = ["first", "second", "third"]
    # @return [<various>] Returns the variable that was assigned.
    def []=(key, value)
      @config[key] = value
      # automatically save to file if this has been requested.
      save unless @options[:autosave] == false
    end

    # Returns the fully qualified path to the configuration file in use.
    # @example
    #   path = config_path
    # @return [String] Full path and filename of the configuration file.
    def config_path
      File.expand_path(File.join(@options[:location], @options[:filename]))
    end

    private

    def save_to_yaml
      unless File.exist?(config_path)
        @status.set(config_exists: false, errors: Status::ERR_FILE_NOT_EXIST)
        return
      end
      File.open(config_path, 'w') { |file| file.write(@config.to_yaml) }
    rescue
      @status.set(errors: Status::ERR_CANT_SAVE_CONFIGURATION)
    end

    def create_new_file
      File.new(config_path, 'w').close
      @status.set(config_exists: true, errors: Status::INFO_FILE_CREATED)
    rescue
      @status.set(config_exists: false, errors: Status::ERR_CANT_CREATE_FILE)
    end

    def check_exists(options)
      @status[:config_exists] = true
      return if File.exist?(config_path)

      # file does not exist so we create if requested otherwise error out
      if options[:create_file] == true
        create_new_file
      else
        @status.set(config_exists: false, errors: Status::ERR_FILE_NOT_EXIST)
      end
    end
  end
end
