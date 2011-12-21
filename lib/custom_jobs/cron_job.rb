class CronJob < Struct.new( :time )

  DEFAULT_PRIORITY                = 0
  
  # queue with our default priority
  def self.enqueue
    Delayed::Job.enqueue( CronJob.new( time=DateTime.now ), {:priority => DEFAULT_PRIORITY} )
  end

  def perform
    Rails.logger.info "cron... started [#{Time.now.hour}]"
    ExpungeTitlesJob.enqueue( 5 )
    Rails.logger.info "cron... finished  [#{Time.now.hour}]"
  end
  
  def error( job, exception )
    Rails.logger.info job.last_error unless job.nil? or job.last_error.nil?
  end
end