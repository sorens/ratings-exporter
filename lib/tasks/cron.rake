desc "task run by Heroku cron"
task :cron => :environment do
  CronJob.enqueue
end