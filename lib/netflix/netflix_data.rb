class NetflixData
  
  TYPE_DVD          = "dvd"
  TYPE_STREAMED     = "streamed"
  
  attr_accessor :response, :records
  
  def initialize( response )
    @response = response
    @records = []
  end
  
  #<Nokogiri::XML::Element:0x824c5f40 name="link" 
  #namespace=#<Nokogiri::XML::Namespace:0x824c6be8 href="http://www.w3.org/2005/Atom"> 
  #attributes=[#<Nokogiri::XML::Attr:0x824c5ec8 name="href" 
  #value="http://api-public.netflix.com/catalog/titles/movies/60036238">, 
  #<Nokogiri::XML::Attr:0x824c5eb4 name="rel" 
  #value="http://schemas.netflix.com/catalog/title">, 
  #<Nokogiri::XML::Attr:0x824c5ea0 name="title" value="I, Robot">]>]
  
  # xml.xpath( '//*[@rel="http://schemas.netflix.com/catalog/title"]')
  #
  # <nflx:watched_date>2011-06-27T07:44:02Z</nflx:watched_date>
  # <nflx:shipped_date>2011-11-09T18:01:57Z</nflx:shipped_date>

  def extract
    return if @response.nil?
    begin
      start_count = @records.length
      xml = Nokogiri::XML @response do |config|
        config.strict.noent.noblanks
      end
      entries = xml.xpath( '//xmlns:entry' )
      if entries
        entries.each do |entry|
          id = extract_id( entry )
          year = extract_year( entry )
          type = extract_type( entry )
          viewed_date = extract_date( entry, type )
          title = extract_title( entry )
          url = extract_url( entry )
          @records << { :id => id, :year => year, :type => type, :viewed_date => viewed_date, :title => title, :url => url }
        end
        end_count = @records.length
        Rails.logger.info "extracted [#{end_count-start_count}] records"
      end
    rescue Exception => e
      Rails.logger.error "failed to extract data [#{e.class}] with [#{e.message}]"
    end
  end
  
private
  def extract_title( element )
    title = ""
    begin
      title = element.xpath( 'xmlns:link[@rel="http://schemas.netflix.com/catalog/title"]' ).first['title']
    rescue
    end
    
    title
  end
  
  def extract_type( element)
    type = TYPE_DVD
    begin
      if element.xpath( 'nflx:shipped_date' ).text.blank?
        type = TYPE_STREAMED
      end
    rescue
    end
    
    type
  end
  
  def extract_date( element, type )
    date = ""
    begin
      type = extract_type( element ) if type.blank?
      if type == TYPE_DVD
        date = element.xpath( 'nflx:shipped_date' ).text
      else
        date = element.xpath( 'nflx:watched_date' ).text
      end
    rescue
    end
    
    date
  end
  
  def extract_id( element )
    id = ""
    begin
      # the id is embedded in a url. locally it's the final
      # value, just split it by / and grab the last one
      id = element.xpath( 'xmlns:id' ).text.split( "/" ).last
    rescue
    end
    
    id
  end
  
  def extract_year( element )
    year = ""
    begin
      year = element.xpath( 'nflx:release_year' ).text
    rescue
    end
    
    year
  end
  
  def extract_url( element )
    url = ""
    begin
      url = element.xpath( 'xmlns:link[@rel="http://schemas.netflix.com/catalog/title"]' ).first['href']
    rescue
    end
    
    url
  end
end