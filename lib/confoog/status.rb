# Provide error messages and console output when required.
class Status
  # No error condition exists
  ERR_NO_ERROR = 0
  # The specified file does not exist
  ERR_FILE_NOT_EXIST = 1
  # Was unable to create the specified file
  ERR_CANT_CREATE_FILE = 2
  # There are no configuration variables set, so not writing empty file
  ERR_NOT_WRITING_EMPTY_FILE = 4
  # Cannot save to the specified file for some reason
  ERR_CANT_SAVE_CONFIGURATION = 8
  # The specified file is empty so not trying to load settings from it
  ERR_NOT_LOADING_EMPTY_FILE = 16
  # Cannot load the specified file for some reason.
  ERR_CANT_LOAD = 32

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
    # ititialize a hash to store our own internal options.
    @options = {}
    # and fill it.
    @options[:quiet] = quiet
    @options[:prefix] = prefix
  end

  # Set whether we output to the console or not
  # @param quiet [Boolean] True to output Errors to the console.
  # @return [Boolean] Value of #quiet
  def quiet=(quiet)
    @options[:quiet] = quiet
  end

  # return the current 'quiet' status
  # @return [Boolean] Value of #quiet
  def quiet
    @options[:quiet]
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
    status.each { |key, value| @status[key] = value }
    return unless error_string
    console_output(error_string, (@status[:errors] < 256) ? 'Error' : 'Info')
  end

  private

  # return the error string corresponding to the current error number
  def error_string
    ERROR_STRINGS[@status[:errors]]
  end

  # Display output to the console with the severity noted, unless we are quiet.
  # @param [String] message
  def console_output(message, severity)
    return unless @options[:quiet] == false
    $stderr.puts "#{@options[:prefix]} : #{severity} - #{message}"
  end
end
