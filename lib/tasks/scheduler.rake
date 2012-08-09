desc "This task is called by the Heroku scheduler add-on"
task :expunge_titles => :environment do
    Rails.logger.info "cron... started [#{Time.now.hour}]"
    ExpungeTitlesJob.enqueue( 5 )
    Rails.logger.info "cron... finished  [#{Time.now.hour}]"
end