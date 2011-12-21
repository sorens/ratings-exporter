ActiveAdmin.register Title do
  
  scope :all, :default => true
  scope :fivedaysold
  
  filter :name
  filter :year
  filter :url
  filter :rating
  filter :netflix_type
  filter :viewed_date
  filter :created_at
end
