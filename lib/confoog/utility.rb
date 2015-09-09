# A collection of utility functions for the Confoog class
module ConfoogUtils
  private

  # Display output to the console with the severity noted, unless we are quiet.
  def console_output(message, severity)
    return unless @options[:quiet] == false
    $stderr.puts "#{@options[:prefix]} : #{severity} - #{message}"
  end
end
