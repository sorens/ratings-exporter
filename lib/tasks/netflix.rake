namespace :netflix do
  desc "ask netflix for an oauth_verifier"
  task :login => :environment do
    puts "--------------------------------------------------------------------------"
    puts "[#{DateTime.now}] starting login to Netlfix"
    puts "--------------------------------------------------------------------------"
    start_login
  end
  
  desc "generate the access_token"
  task :token, [:verifier] => :environment do |t,args|
    puts "--------------------------------------------------------------------------"
    puts "[#{DateTime.now}] creating access_token from [#{args.verifier.to_s}]"
    puts "--------------------------------------------------------------------------"
    handle_login( args.verifier.to_s )
  end
  
  desc "feeds"
  task :feeds => :environment do
    puts "--------------------------------------------------------------------------"
    puts "[#{DateTime.now}] request the feeds for this user"
    puts "--------------------------------------------------------------------------"
    access_token = at_load
    if access_token
      begin
        user_id = access_token.params['user_id']
        response = access_token.get( "/users/#{user_id}/feeds" )
        puts access_token.inspect
        puts response.inspect
        user_feed = UserFeed.new( response )
        user_feed.extract
        puts "shipped:\r\n#{user_feed.shipped}"
        puts "watched:\r\n#{user_feed.watched}"
        puts "history:\r\n#{user_feed.history}"
        puts "disc_queue:\r\n#{user_feed.disc_queue}"
        puts "instant_queue:\r\n#{user_feed.instant_queue}"
        puts "reviews:\r\n#{user_feed.reviews}"
        puts "recommendations:\r\n#{user_feed.recommendations}"
        puts "ratings:\r\n#{user_feed.ratings}"
      rescue Exceptions::OauthHelperException => e
        puts "failed to request [#{e.class}] for [#{e.message}]"
      end
    else
      puts "access_token not available, be sure to login"
    end
  end

  RESERVED = /[^A-Za-z0-9\-\._~]/
  
  desc "batch test"
  task :batch, [:url] => :environment do |t,args|
    puts "--------------------------------------------------------------------------"
    puts "[#{DateTime.now}] batch request ratings"
    puts "--------------------------------------------------------------------------"
    refs = []
    access_token = at_load
    if access_token
      user_id = access_token.params['user_id']
      feed = Feed.new( "batch", args.url.to_s )
      feed.download
      if feed.responses
        feed.responses.each do |resp|
          data = NetflixData.new( resp )
          data.extract
          if data.records
            unless user_id.nil?
              data.records.each do |record|
                refs << record[:url]
              end
            end
          end
        end
        if refs and refs.length > 0
          begin
            tmp = refs[0..499]
            title_refs = tmp.collect { |r| r }.join(",")
            puts "[#{tmp.count}] title_refs: [#{title_refs}]"
            rating_url = "/users/#{user_id}/ratings/title"
            resp = access_token.post( rating_url, { :title_refs => title_refs, :method => "GET" } )
            xml = Nokogiri::XML( resp.body.to_s )
            count = xml.xpath( "//user_rating" ).count
            puts "there are [#{count}]"
            puts resp.inspect
            puts xml
          rescue Exception => e
            puts e.message
            puts e.backtrace
          end
        end
      else
        puts "there are no responses for [#{url}]"
      end
    end
  end
  
  private
  def start_login
    callback_url = "oob"
    consumer = OauthHelper.create_consumer
    request_token = consumer.get_request_token( :oauth_callback => callback_url )
    url = request_token.authorize_url( :oauth_callback => callback_url, :oauth_consumer_key => Rails.application.config.netflix_app_key,
    :application_name => "exporter" )
    puts "authorize_url: [#{url}]"
    rt_dump( request_token )
    `open '#{url}'`
  end
  
  def handle_login( verifier )
    request_token = rt_load
    begin
      access_token = request_token.get_access_token( :oauth_verifier => verifier )
      user_id = access_token.params['user_id']
      token = access_token.token
      secret = access_token.secret
      puts "user_id: [#{user_id}] authorized"
      at_dump( access_token )
      return access_token
    rescue OAuth::Unauthorized => e
      puts "failed to sign in [#{e.message}]"
    end
  end
  
  REQUEST_TOKEN_TMP_PATH = File.expand_path( "/tmp/netflix_rt_123.dump" )
  ACCESS_TOKEN_TMP_PATH = File.expand_path( "/tmp/netflix_at_123.dump" )
  
  # dump access_token
  def at_dump( access_token )
    t_dump( access_token, ACCESS_TOKEN_TMP_PATH )
  end
  # load access_token
  def at_load
    t_load( ACCESS_TOKEN_TMP_PATH )
  end
  # dump request_token
  def rt_dump( request_token )
    t_dump( request_token, REQUEST_TOKEN_TMP_PATH )
  end
  # load request_token
  def rt_load
    t_load( REQUEST_TOKEN_TMP_PATH )
  end
  # dump a token
  def t_dump( token, path )
    File.open( path, "wb" ) { |io| Marshal.dump( token, io ) }
    puts "token dumped to [#{path}]"
  end
  # load a token
  def t_load( path )
    if File.file?( path )
      puts "token loaded from [#{path}]"
      return File.open( path, "rb" ) { |io| Marshal.load( io.read ) }
    end
  end
end