module ApplicationHelper
  def generate_title_json( title )
    {
      :id => title.netflix_id,
      :title => title.name,
      :year => title.year,
      :url => title.url,
      :rating => title.rating,
      :type => title.netflix_type,
      :viewed_date => title.viewed_date,
      :exported => title.exported
    }
  end
end
