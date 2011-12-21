class ExpungeTitlesJob < Struct.new( :days )
  
  DEFAULT_PRIORITY = 5

  # queue with our default priority
  def self.enqueue( days )
    Delayed::Job.enqueue( ExpungeTitlesJob.new( days ), {:priority => DEFAULT_PRIORITY} )
  end
  
  def perform
    Title.where( 'created_at < ?', days.to_s.to_i.days.ago  ).find_each( :batch_size => 100 ) do |title|
      title.delete
    end
  end
  
  def error( job, exception )
    Rails.logger.error job.last_error unless job.nil? or job.last_error.nil?  
  end
end