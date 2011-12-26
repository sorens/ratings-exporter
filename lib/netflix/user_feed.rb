class UserFeed
  
  KEY_SHIPPED         = "shipped"
  KEY_WATCHED         = "watched"
  KEY_HISTORY         = "history"
  KEY_DISC_QUEUE      = "disc.queue"
  KEY_INSTANT_QUEUE   = "instant.queue"
  KEY_REVIEWS         = "reviews"
  KEY_RECOMMENDATIONS = "recommendations"
  KEY_RATINGS         = "ratings"
  
  attr_accessor :response, :feeds

  # <link href="rental_history/shipped?" 
  #   rel="http://schemas.netflix.com/feed.rental_history.shipped" 
  #   title="Titles Shipped"></link>
  # <link href="rental_history/watched?" 
  #   rel="http://schemas.netflix.com/feed.rental_history.watched" 
  #   title="Titles Watched Recently"></link>
  
  RENTAL_HISTORY    = '//*[@rel="http://schemas.netflix.com/feed.rental_history"]'
  SHIPPED_HISTORY   = '//*[@rel="http://schemas.netflix.com/feed.rental_history.shipped"]'
  WATCHED_HISTORY   = '//*[@rel="http://schemas.netflix.com/feed.rental_history.watched"]'
  DISC_QUEUE        = '//*[@rel="http://schemas.netflix.com/feed.queues.disc"]'
  INSTANT_QUEUE     = '//*[@rel="http://schemas.netflix.com/feed.queues.instant"]'
  REVIEWS           = '//*[@rel="http://schemas.netflix.com/feed.reviews"]'
  RECOMMENDATIONS   = '//*[@rel="http://schemas.netflix.com/feed.recommendations"]'
  RATINGS           = '//*[@rel="http://schemas.netflix.com/feed.ratings"]'
  
  def initialize( response )
    @response = response
    @feeds = {}
  end
  
  def extract
    return if @response.nil?
    xml = Nokogiri::XML( @response.body )
    extract_link( SHIPPED_HISTORY, KEY_SHIPPED, xml )
    extract_link( WATCHED_HISTORY, KEY_WATCHED, xml )
    extract_link( RENTAL_HISTORY, KEY_HISTORY, xml )
    extract_link( DISC_QUEUE, KEY_DISC_QUEUE, xml )
    extract_link( INSTANT_QUEUE, KEY_INSTANT_QUEUE, xml )
    extract_link( REVIEWS, KEY_REVIEWS, xml )
    extract_link( RECOMMENDATIONS, KEY_RECOMMENDATIONS, xml )
    extract_link( RATINGS, KEY_RATINGS, xml )
  end
  
  def extract_link( search, key, xml )
    element = xml.xpath( search ).first
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
  
  def history
    @feeds[KEY_HISTORY]
  end

  def disc_queue
    @feeds[KEY_DISC_QUEUE]
  end

  def instant_queue
    @feeds[KEY_INSTANT_QUEUE]
  end

  def reviews
    @feeds[KEY_REVIEWS]
  end

  def recommendations
    @feeds[KEY_RECOMMENDATIONS]
  end

  def ratings
    @feeds[KEY_RATINGS]
  end
end