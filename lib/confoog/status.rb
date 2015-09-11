# Provide error messages and console output when required.
class Status
  # @!attribute prefix
  #   @return [String] String to pre-pend on any error put to console
  attr_accessor :prefix
  # @!attribute quiet
  #   @return [Boolean] Do we output anything to console or not
  attr_accessor :quiet
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
  # Cannot load the specified file for some reason.
  ERR_CANT_LOAD = 64

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

  # Hash containing the error messages for each ERR condition. If an ERR does
  # not have a message, there will be no output.
  ERROR_STRINGS = {
    ERR_FILE_NOT_EXIST => 'The specified Configuration file does not exist.',
    ERR_CANT_CHANGE => 'Cannot change filename after creation',
    ERR_CANT_CREATE_FILE => 'Cannot create the specified Configuration file!',
    ERR_NOT_WRITING_EMPTY_FILE => 'Not saving empty configuration data!',
    ERR_CANT_SAVE_CONFIGURATION => 'Cannot save configuration data!',
    ERR_NOT_LOADING_EMPTY_FILE => 'The configuration file is empty!',
    ERR_CANT_LOAD => 'Cannot load configuration Data!'
  }

  # Class initializer.
  # @example
  #   status = Status.new(quiet: true, prefix: "My Fab App")
  # @param quiet [Boolean] Do we output to the console?
  # @param prefix [String] Prefix to put before any error message.
  def initialize(quiet, prefix)
    # Initialize the status container to an empty hash. Will return nil
    # for missing keys by default.
    @status = {}
    @quiet = quiet
    @prefix = prefix
  end

  # Clear the error status.
  # @example
  #   status.clear_error
  # @return [Integer] 0
  def clear_error
    @status[:errors] = ERR_NO_ERROR
  end

  # Read the value of a status.
  # @example
  #   key = status[:key]
  # @return [<various>] Return value depends on the type of variable stored
  def [](key)
    @status[key]
  end

  # Set the value of status.
  # @example
  #   status[:key] = "Value"
  #   status[:error] = ERR_NOT_LOADING_EMPTY_FILE
  # @param key [Any] Key name to be added or updated.
  # @param value [Any] New value for the status. May be any type.
  # @return [<various>] Returns the value that was assigned.
  def []=(key, value)
    @status[key] = value
  end

  # Set one or multiple status variables, optionally outputing a console
  # message if one exists for that status.
  # @example
  #   status.set(errors: Status::ERR_CANT_SAVE_CONFIGURATION)
  # @param status [Hash] one or more hash-pairs of status information.
  # @return Unspecified
  def set(status)
    status.each do |key, value|
      @status[key] = value
    end
    return if ERROR_STRINGS[@status[:errors]].nil?
    console_output(ERROR_STRINGS[@status[:errors]], 'Error')
  end

  private

  # Display output to the console with the severity noted, unless we are quiet.
  # @param [String] message
  def console_output(message, severity)
    return unless @quiet == false
    $stderr.puts "#{@prefix} : #{severity} - #{message}"
  end
end
