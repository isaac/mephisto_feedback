class Admin::FeedbackController < Admin::BaseController

  skip_before_filter :login_required
  before_filter :login_required, :except => :create
  before_filter :find_feedback, :only => [ :show, :destroy ]
  member_actions << 'index' << 'show'

  def index
    conditions = returning [[]] do |cond|
      unless params[:key].blank?
        cond.first << "#{Feedback.connection.quote_column_name :key} = ?"
        cond       << params[:key]
      end
      unless params[:name].blank?
        cond.first << 'name LIKE ? OR email LIKE ?'
        cond       << "#{params[:name]}%" << "#{params[:name]}%"
      end
      unless params[:q].blank?
        cond.first << 'body LIKE ?'
        cond       << "%#{params[:body]}%"
      end
      cond.unshift cond.shift.join(" OR ") if cond.first.any?
    end
    @feedbacks = site.feedbacks.paginate \
      :page => params[:page],
      :per_page => 50,
      :order => 'created_at desc',
      :conditions => conditions.first.blank? ? nil : conditions
  end
  
  def destroy
    @feedback.destroy
    flash[:notice] = Mephisto::Plugin[:feedback].destroy_msg
    redirect_to :action => 'index'
  end
  
  def clear
    site.feedbacks.delete_all
    flash[:notice] = Mephisto::Plugin[:feedback].clear_msg
    redirect_to :action => 'index'
  end
  
  def create
    Feedback.create_from(site, params[:feedback]) if params[:feedback]
    redirect_to Mephisto::Plugin[:feedback].redirect
  rescue
    Feedback.create_error_from(site, params[:feedback] || {}, $!)
  end
  
  protected
  
  def find_feedback
    @feedback = site.feedbacks.find params[:id]
  end
  
end
