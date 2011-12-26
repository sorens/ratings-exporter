class IgnoreUnfinishedJob < Struct.new( :token, :secret, :user_id )

  DEFAULT_PRIORITY          = 2
  
  def self.enqueue( token, secret, user_id )
    Delayed::Job.enqueue( IgnoreUnfinishedJob.new( token, secret, user_id ), { :priority => DEFAULT_PRIORITY, :queue => user_id } )
  end
  
  def perform
    Title.where( :user_id => user_id, :exported => 0 ).find_each( :batch_size => 100 ) do |title|
      if title
        title.exported = 2
        title.save
      end
    end
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
end