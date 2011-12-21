ActiveAdmin.register DelayedJob do
  
  filter :priority
  filter :handler
  filter :last_error
  filter :queue
  filter :created_at
end
