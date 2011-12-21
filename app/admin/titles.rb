ActiveAdmin.register Title do
  
  scope :all, :default => true
  scope :fivedaysold
  scope :unfinished
  scope :finished
  
  filter :name
  filter :year
  filter :url
  filter :rating
  filter :exported
  filter :user_id
  filter :netflix_type
  filter :viewed_date
  filter :created_at
end
