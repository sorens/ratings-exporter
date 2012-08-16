ActiveAdmin.register DelayedJob do
  
  filter :handler
  filter :last_error
  filter :queue
  filter :created_at

  index do
	column :id
  	column :priority
  	column :queue
  	column :last_error do |resource|
  		if resource.last_error
  			status_tag( "error", :warning )
  		end
  	end
  	column :attempts
  	column :run_at
  	# column :locked_at
  	# column :failed_at
  	# column :locked_by
  	column :created_at
  	# column :updated_at
  	default_actions
  end

  	# this block customizes the show page
  	show :title => :id do |resource|
	    attributes_table do
	    	row :priority
	    	row :attempts
	    	row :run_at
	    	row :locked_at
	    	row :failed_at
	    	row :locked_by
	    	row :queue
	    end
	    if resource.last_error.present?
		    div :class => "panel" do 
		    	h3 "Last Error"
				div :class => "panel_contents" do 
					div :class => "attributes_table" do 
						pre do
		            		resource.last_error
		            	end
		          	end
		        end
		    end
		end
	    div :class => "panel" do 
	    	h3 "Handler"
			div :class => "panel_contents" do 
				div :class => "attributes_table" do 
					pre do
	            		resource.handler
	            	end
	          	end
	        end
	    end
	end
end
