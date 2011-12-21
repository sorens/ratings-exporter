class DownloadRatingJob < Struct.new( :rec_id, :title_url, :token, :secret, :user_id )

  DEFAULT_PRIORITY          = 2
  
  def self.enqueue( rec_id, title_url, token, secret, user_id )
    Delayed::Job.enqueue( DownloadRatingJob.new( rec_id, title_url, token, secret, user_id ), { :priority => DEFAULT_PRIORITY, :queue => user_id } )
  end
  
  def perform
    rating = Rating.new( rec_id, title_url, token, secret, user_id )
    rating.fetch_rating_and_save_record
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
end