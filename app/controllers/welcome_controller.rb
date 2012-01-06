class WelcomeController < ApplicationController
  before_filter :verify_session, :except => [:sign_out,:index]
  before_filter :process_flash
  respond_to :json, :html
  
  def index
    if session[:user_id]
      user_id = session[:user_id]
      
      @jobs = DelayedJob.where( :queue => user_id ).count
      if @jobs > 0
        render 'in_progress', :locals => { :count => @jobs } and return
      end
      
      @unfinished = Title.where( :user_id => user_id, :exported => 0 ).count
      if @unfinished > 0
        render 'un_finished', :locals => { :count => @unfinished } and return
      end
      
      @titles = Title.where( :user_id => user_id, :exported => 1 ).count
      if @titles > 0
        render 'result' and return
      end
    end
  end
  
  def sign_out
    session[:user_id] = nil
    session[:access_token] = nil
    session[:secret] = nil
    redirect_to :root, :notice => "You have been signed out."
  end
  
  def progress
    user_id = session[:user_id]
    progress = DelayedJob.where( :queue => user_id ).count
    json = { :jobs => progress }
    if progress == 0 and request.xhr?
      progress = Title.where( :user_id => user_id, :exported => 0 ).count
      if progress > 0
        flash[:alert] = "We were unable to export all your ratings."
        json[:location] = url_for( :controller => :welcome, :action => :index )
      else
        flash[:notice] = "Your export has finished"
        json[:location] = url_for( :controller => :welcome, :action => :index )
      end
    elsif progress == 0 and ! request.xhr?
      redirect_to :root, :notice => "Your export has finished." and return
    end
    respond_to do |format|
      format.json { render :json => json, :status => 200 }
      format.html { render 'in_progress', :locals => { :count => progress } and return }
    end
  end
  
  def download
    @titles = Title.find_all_by_user_id( session[:user_id] )
    if @titles.count > 0
      respond_to do |format|
        format.json {
          respond_with( @titles )
        }
      end
    else
      redirect_to :root, :alert => "There were no records to export."
    end
  end
  
  def continue
    QueueUnfinishedJob.enqueue( session[:access_token], session[:secret], session[:user_id] )
    redirect_to progress_path, :notice => "Your unfinished exports have been queued."
  end
  
  def ignore
    IgnoreUnfinishedJob.enqueue( session[:access_token], session[:secret], session[:user_id] )
    redirect_to progress_path, :alert => "Ignoring your unfinished exports."
  end

private
  def verify_session
    unless session[:user_id]
      redirect_to :root, :alert => "You must authenticate first."
    end
  end
  
  def process_flash
    if params[:alert]
      flash.now[:alert] = params[:alert]
    end
    if params[:notice]
      flash.now[:notice] = params[:notice]
    end
    if params[:error]
      flash.now[:error] = params[:error]
    end
  end
end