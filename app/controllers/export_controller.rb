class ExportController < ApplicationController
  
  def export
    if session[:access_token] and session[:secret]
      handle_callback( session[:access_token], session[:secret] )
    else
      callback_url = "http://#{Rails.application.config.oauth_callback_domain}/export_callback/"
      consumer = OauthHelper.create_consumer
      request_token = consumer.get_request_token( :oauth_callback => callback_url )
      session[:request_token] = request_token
      url = request_token.authorize_url( :oauth_callback => callback_url, :oauth_consumer_key => Rails.application.config.netflix_app_key,
      :application_name => "exporter" )
      redirect_to url
    end
  end
  
  def export_callback
    handle_callback( nil, nil, params[:oauth_verifier] )
  end

private
  def handle_callback( token, secret, oauth_verifier=nil )
    request_token = session[:request_token]
    callback_url = "http://#{Rails.application.config.oauth_callback_domain}/export_callback/"
    consumer = OauthHelper.create_consumer
    unless request_token
      request_token = consumer.get_request_token( :oauth_callback => callback_url )
      session[:request_token] = request_token
    end
    
    if token and secret
      access_token = OAuth::AccessToken.new( consumer, token, secret )
      user_id = session[:user_id]
    elsif oauth_verifier
      begin
        access_token = request_token.get_access_token( :oauth_verifier => oauth_verifier )
        user_id = access_token.params['user_id']
        token = access_token.token
        secret = access_token.secret
        Rails.logger.info "user_id: [#{user_id}] authorized"
      rescue OAuth::Unauthorized => e
        Rails.logger.error "failed to sign in [#{e.message}]"
        redirect_to :welcome, :alert => "Netflix failed to authorize." and return
      end
    end
    
    session[:access_token] = token
    session[:user_id] = user_id
    session[:secret] = secret
    
    msg = { :notice => "Your export has been queued." }
    titles = Title.where( :user_id => user_id ).count
    jobs = DelayedJob.where( :queue => user_id ).count
    if jobs > 0
      msg = { :notice => "Your export is in progress." }
    elsif titles > 0
      msg = { :notice => "Your export has finished." }
    else
      begin
        response = access_token.get( "/users/#{user_id}/feeds" )
        user_feed = UserFeed.new( response )
        user_feed.extract
        DownloadRentalsJob.enqueue( "shipped", user_feed.shipped, token, secret, user_id )
        DownloadRentalsJob.enqueue( "watched", user_feed.watched, token, secret, user_id )
        DownloadRentalsJob.enqueue( "ratings", user_feed.ratings, token, secret, user_id )
        DownloadRentalsJob.enqueue( "instant", user_feed.instant_queue, token, secret, user_id )
        DownloadRentalsJob.enqueue( "disc", user_feed.disc_queue, token, secret, user_id )
      rescue Exceptions::OauthHelperException => e
        Rails.logger.error "failed to request [#{e.class}] for [#{e.message}]"
        msg = { :error => e.message }
      end
    end
    
    redirect_to :welcome, msg
  end
end
