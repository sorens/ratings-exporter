class DownloadRentalsJob < Struct.new( :name, :url, :token, :secret, :user_id )

  DEFAULT_PRIORITY          = 1
  
  def self.enqueue( name, url, token, secret, user_id )
    Delayed::Job.enqueue( DownloadRentalsJob.new( name, url, token, secret, user_id ), { :priority => DEFAULT_PRIORITY, :queue => user_id } )
  end
  
  def perform
    Rails.logger.info "download rentals job [#{name}], [#{url}]"
    feed = Feed.new( name, url )
    feed.download
    if feed.responses
      feed.responses.each do |resp|
        ExtractNetflixDataJob.enqueue( resp.body.to_str, token, secret, user_id )
      end
    else
      Rails.logger.info "there are no responses for [#{url}]"
    end
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
end