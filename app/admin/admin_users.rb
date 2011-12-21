ActiveAdmin.register AdminUser do
  filter :email
  
  index do
    column :email
    column :current_sign_in_at do |a|
      a.current_sign_in_at.localtime.strftime('%Y-%m-%d %H:%M') unless a.current_sign_in_at.nil?
    end
    column :last_sign_in_at do |a|
      a.last_sign_in_at.localtime.strftime('%Y-%m-%d %H:%M') unless a.last_sign_in_at.nil?
    end
    column :sign_in_count
    default_actions
  end

  show :title => :email do |a|
    attributes_table do
      row :id
      row :email
      row :sign_in_count
      row :current_sign_in_at do
        a.current_sign_in_at.strftime('%Y-%m-%d %H:%M') unless a.current_sign_in_at.nil?
      end
      row :last_sign_in_at do
        a.last_sign_in_at.strftime('%Y-%m-%d %H:%M') unless a.last_sign_in_at.nil?
      end
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at do
        a.created_at.localtime.strftime('%Y-%m-%d %H:%M') unless a.created_at.nil?
      end
      row :updated_at do
        a.updated_at.localtime.strftime('%Y-%m-%d %H:%M') unless a.updated_at.nil?
      end
    end
  end
  
  form do |f|
    if f.object.new_record?
      f.inputs "New Admin" do
        f.input :email
      end
    else
      f.inputs "Edit Admin" do
        f.input :email
      end
    end
    f.buttons
  end
  
  controller do
    def create
      email = params[:admin_user][:email]
      if AdminUser.find_by_email( email ).nil?
        au = AdminUser.new
        au.email = email
        au.save
        message = "Admin User [#{au.email}] was created."
      else
        message = "There is already an Admin User for [#{email}]"
      end
      redirect_to admin_admin_users_path, :notice => message
    end
  end
end
