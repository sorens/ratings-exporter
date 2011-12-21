require 'simple_logger'

class LogToUserDir
  
  LOGS_DIR    = "~/Library/Logs"
  
  def self.load
    # use our simple logger class so we can see a date time stamp for each entry
    log_dir = File.expand_path( File.join( LOGS_DIR, Rails.application.class.parent_name ) )
    FileUtils.mkdir_p( log_dir )
    path = File.join( log_dir, "#{Rails.env}.log" )
    logfile = File.open( path, 'a' )
    logfile.sync = true
    Rails.logger = SimpleLogger.new( logfile )
    Rails.logger.debug "Configured to use SimpleLogger"
    if defined?( Delayed::Worker )
      Delayed::Worker.logger = Rails.logger
      Rails.logger.debug "Delayed::Worker configured to use SimpleLogger"
    end
  end
end