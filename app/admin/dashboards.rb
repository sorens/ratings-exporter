ActiveAdmin::Dashboards.build do
  
  section "Recent Users: #{Title.select( "DISTINCT(user_id)" ).count}" do
    table_for Title.select( "DISTINCT(user_id)" ).limit(50) do
      column "USER_ID" do |c| link_to c.user_id, admin_titles_path(c) end
      column "UPDATED" do |c|
        "#{Title.where( :user_id => c.user_id ).order( "updated_at desc" ).limit(1).first.updated_at.to_time.localtime.to_formatted_s( :short )}"
      end
    end
  end

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
