class Title < ActiveRecord::Base
  
  scope :fivedaysold, where( 'created_at < ?', 5.days.ago )
  scope :unfinished, where( 'exported = 0' )
  scope :finished, where( 'exported = 1' )

  def to_json
    {
      :id => self.netflix_id,
      :title => self.name,
      :year => self.year,
      :url => self.url,
      :rating => self.rating,
      :type => self.netflix_type,
      :viewed_date => self.viewed_date,
      :exported => self.exported
    }
  end
  
  def to_csv
    FasterCSV.generate do |csv|
      csv << ["#{self.id}","#{self.name}","#{self.year}","#{self.url}","#{self.rating}","#{self.type}","#{self.viewed_date}","#{self.exported}"]
    end
  end

end
