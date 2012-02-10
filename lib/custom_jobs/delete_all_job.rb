class DeleteAllJob < Struct.new( :token, :secret, :user_id )

  DEFAULT_PRIORITY          = 2
  
  def self.enqueue( token, secret, user_id )
    Delayed::Job.enqueue( DeleteAllJob.new( token, secret, user_id ), { :priority => DEFAULT_PRIORITY, :queue => user_id } )
  end
  
  def perform
    Title.delete_all( :user_id => user_id )
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
end
