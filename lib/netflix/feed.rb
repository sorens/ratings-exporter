# download the entire feed
class Feed
  
  attr_accessor :name, :url, :start, :max, :responses
  
  def initialize( name, url, start=0, max=500)
    @name = name
    @url = url
    @responses = []
    @max = 500
    @start = 0
  end
  
  def download
    return if @url.nil?
    
    continue = true
    
    begin
      while continue
        paged_url = "#{url}&#{page}"
        Rails.logger.debug "[#{name}] requesting [#{@start}] to [#{@start+@max-1}]"
        resp =  RestClient.get paged_url
        xml = Nokogiri::XML resp.to_s
        results_per_page = xml.xpath( "//nflx:results_per_page" ).text.to_i
        if results_per_page
          # perhaps there was no results_per_page tag, try counting entries
          results_per_page = xml.xpath( '//xmlns:entry' ).count
          results_per_page = xml.xpath( '//entry' ).count if results_per_page == 0
        end
        Rails.logger.info "[#{name}] there are [#{results_per_page}]"
        @responses << resp
        if results_per_page >= @max
          @start = @start + @max
        else
          continue = false
        end
      end
    rescue RestClient::Request::Unauthorized => unauthorized
      Rails.logger.error "[#{name}]: unauthorized [#{unauthorized.message}]"
    rescue RestClient::Exception => re
      Rails.logger.error "[#{name}]: exception [#{re.message}] [#{re.class}]"
    end
    
  end
  
  private
  def page
    "start_index=#{start}&max_results=#{max}"
  end
end