class UserFeed
  
  KEY_SHIPPED       = "shipped"
  KEY_WATCHED       = "watched"
  
  attr_accessor :response, :feeds

  # <link href="rental_history/shipped?" 
  #   rel="http://schemas.netflix.com/feed.rental_history.shipped" 
  #   title="Titles Shipped"></link>
  # <link href="rental_history/watched?" 
  #   rel="http://schemas.netflix.com/feed.rental_history.watched" 
  #   title="Titles Watched Recently"></link>
  
  RENTAL_HISTORY = '//*[@rel="http://schemas.netflix.com/feed.rental_history"]'
  SHIPPED_HISTORY = '//*[@rel="http://schemas.netflix.com/feed.rental_history.shipped"]'
  WATCHED_HISTORY = '//*[@rel="http://schemas.netflix.com/feed.rental_history.watched"]'
  
  def initialize( response )
    @response = response
    @feeds = {}
  end
  
  def extract
    return if @response.nil?
    xml = Nokogiri::XML( @response.body )
    shipped = xml.xpath( SHIPPED_HISTORY ).first
    watched = xml.xpath( WATCHED_HISTORY ).first
    extract_link( shipped, KEY_SHIPPED )
    extract_link( watched, KEY_WATCHED )
  end
  
  def extract_link( element, key )
    if element and element['href']
      @feeds[key] = element['href']
    end
  end
  
  def shipped
    @feeds[KEY_SHIPPED]
  end
  
  def watched
    @feeds[KEY_WATCHED]
  end
end