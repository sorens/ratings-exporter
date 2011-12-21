class Title < ActiveRecord::Base
  
  scope :fivedaysold, where( 'created_at < ?', 5.days.ago )
  scope :unfinished, where( 'exported = 0' )
  scope :finished, where( 'exported = 1' )
end
