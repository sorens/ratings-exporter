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
  
  index do
    id_column
    column :name
    column :year
    column :url
    column :rating
    column :exported
    column :user_id
    column :netflix_type
    column :viewed_date
    column :created_at
    column :updated_at
    default_actions
  end
end
