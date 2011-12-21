class Title < ActiveRecord::Base
  
  scope :fivedaysold, where( 'created_at < ?', 5.days.ago )
end
