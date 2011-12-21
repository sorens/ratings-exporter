module Exceptions
  class OauthHelperException < StandardError
  end

  class NetflixTooManyRequests < OauthHelperException
    def initialize( msg=nil )
      super( "Netflix daily limit reached for this user_id. Try again tomorrow.")
    end
  end

  class NetflixForbidden < OauthHelperException
    def initialize( msg=nil )
      super( "Netflix has invalidated your authorization.")
    end
  end
  
  class NetflixUserIDNotAvailable < OauthHelperException
    def initialie( msg=nil )
      super( "Unable to retrieve your Netflix user_id." )
    end
  end
end