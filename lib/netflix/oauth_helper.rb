class OauthHelper
  
  def self.create_consumer
      consumer = OAuth::Consumer.new( Rails.application.config.netflix_app_key, Rails.application.config.netflix_app_secret,
        :site => "http://api-public.netflix.com",
        :request_token_url => "http://api-public.netflix.com/oauth/request_token",
        :access_token_url => "http://api-public.netflix.com/oauth/access_token", 
        :authorize_url => "https://api-user.netflix.com/oauth/login" )
  end
end