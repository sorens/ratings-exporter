# batch rating download
class BatchRating
  
  attr_accessor :token, :secret, :user_id
  
  def initialize( token, secret, user_id )
    @token = token
    @secret = secret
    @user_id = user_id
    @urls = []
    @results = {}
  end
  
  def add_url( url )
    @urls <<  url
  end
  
  def fetch_ratings_and_save_records
    if @urls and @urls.count > 0
      begin
        consumer = OauthHelper.create_consumer
        access_token = OAuth::AccessToken.new( consumer, @token, @secret )
        rating_url = "/users/#{@user_id}/ratings/title"
        start = 0
        length = 500
        while start < @urls.count
          tmp = @urls[0..length-1]
          start = start + length
          title_refs = tmp.join(",")
          resp = access_token.post( rating_url, { :title_refs => title_refs, :method => "GET" } )
          Rails.logger.info "batch response [#{resp.inspect}]"
          xml = Nokogiri::XML( resp.body.to_s )
          elements = xml.xpath( "//ratings_item" )
          elements.each do |element|
            id = element.xpath( 'id' ).text.split("/").last
            rating = element.xpath( 'user_rating' ).text

            if Rails.env == "development"
              unless id.blank?
                Rails.logger.debug "[#{@user_id}] rating for [#{id}] is [#{rating}]"
              end
            end
            
            unless id.blank?
              @results[id] = rating
            else
              if Rails.env == "development"
                Rails.logger.debug "failed element [#{element.inspect}]"
              end
            end
          end
        end
        # ratings download and stored in a hash
        # iterate over the ids we have in our url array and update records
        @urls.each do |url|
          netflix_id = url.split("/").last
          begin
            record = Title.find_by_netflix_id_and_user_id( netflix_id, @user_id )
            rating = "0.0"
            rating = @results[netflix_id] if @results.has_key?( netflix_id )
            record.rating = rating
            record.exported = 1
            record.save

            if Rails.env == "development"
              Rails.logger.debug "[#{@user_id}] rating [#{record.rating}] for [#{record.name}] saved"
            end
          rescue ActiveRecord::RecordNotFound => not_found
            Rails.logger.error "batch rating failed to find record [#{netflix_id}]: [#{not_found.message}]"
          end
        end
      rescue Exception => e
        Rails.logger.error "batch rating fetch failed: [#{e.message}]"
      end
    end
  end
  
end