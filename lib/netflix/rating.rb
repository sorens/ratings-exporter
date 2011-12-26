class Rating
  
  RESERVED = /[^A-Za-z0-9\-\._~]/
  
  attr_accessor :rec_id, :title_url, :token, :secret, :user_id
  
  def initialize( rec_id, title_url, token, secret, user_id )
    @rec_id = rec_id
    @title_url = title_url
    @token = token
    @secret = secret
    @user_id = user_id
  end
  
  #<Nokogiri::XML::Element:0x8549c1d8 name="title" attributes=[
  #<Nokogiri::XML::Attr:0x8549c174 name="short" value="Bull Durham">, 
  #<Nokogiri::XML::Attr:0x8549c160 name="regular" value="Bull Durham">]  
  def fetch_rating_and_save_record
    return if @title_url.nil?
    data = nil
    begin
      consumer = OauthHelper.create_consumer
      access_token = OAuth::AccessToken.new( consumer, @token, @secret )
      rating_url = "/users/#{@user_id}/ratings/title?title_refs=#{encoded_title_url}"
      resp = access_token.get( rating_url )
      xml = Nokogiri::XML( resp.body.to_s )
      rating = xml.xpath( "//user_rating" ).text
      rating = "0.0" if rating.blank?
      record = Title.find( rec_id )
      record.exported = 1
      record.rating = rating
      if record.netflix_id.blank?
        record.netflix_id = xml.xpath( "//id" ).text.split( "/" ).last
      end
      if record.name.blank?
        title_tags = xml.xpath( "//title" )
        record.name = title_tags[0]['regular'] unless title_tags.nil? or title_tags[0].nil?
      end
      record.save
      if Rails.env == "development"
        Rails.logger.debug "[#{@user_id}] rating for [#{record.name}] is [#{rating}], seen [#{record.viewed_date}]"
      end
      
    rescue Exception => e
      Rails.logger.error "rating fetch failed for [#{title_url}] [#{e.message}]"
    end
  end
  
  private
  def encoded_title_url
    URI.escape title_url, RESERVED
  end
end