ActionMailer::Base.smtp_settings = {
  :user_name 			=> RatingsExporter::Application.config.sendmail_username,
  :password 			=> RatingsExporter::Application.config.sendmail_password,
  :domain 				=> RatingsExporter::Application.config.mail_host,
  :address 				=> "smtp.sendgrid.net",
  :port 				=> 587,
  :authentication 		=> :plain,
}
# ActionMailer::Base.delivery_method = :smtp