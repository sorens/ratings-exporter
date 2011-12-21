class ExtractNetflixDataJob < Struct.new( :response, :token, :secret, :user_id )

  DEFAULT_PRIORITY          = 1
  
  def self.enqueue( response, token, secret, user_id )
    Delayed::Job.enqueue( ExtractNetflixDataJob.new( response, token, secret, user_id ), { :priority => DEFAULT_PRIORITY, :queue => user_id } )
  end
  
  def perform
    data = NetflixData.new( response )
    data.extract
    if data.records
      consumer = OauthHelper.create_consumer
      access_token = OAuth::AccessToken.new( consumer, token, secret )
      unless user_id.nil?
        data.records.each do |record|
          id = save_record( record )
          DownloadRatingJob.enqueue( id, record[:url], token, secret, user_id )
        end
      end
    end
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
  
private
  def save_record( record )
    id = nil
    Title.transaction do
      rec = Title.find_or_create_by_user_id_and_netflix_id_and_name_and_url_and_year_and_netflix_type( user_id, record[:id], record[:title], record[:url], record[:year], record[:type] )
      rec.viewed_date = record[:viewed_date]
      rec.rating = nil
      rec.exported = 0
      rec.save
      id = rec.id
      if Rails.env == "development"
        Rails.logger.info "[#{@user_id}] title record [#{rec.id}] written for [#{rec.name}] from year [#{rec.year}]"
      end
    end
    id
  end
end