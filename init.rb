module ::Mephisto
  module Plugins
    class Feedback < Mephisto::Plugin
      
      author 'technoweenie / Nick Poulden / isaac'
      version '0.4'
      notes "Create arbitrary feedback forms with Mephisto. See the README. Port of the original mephisto_feedback plugin by technoweenie."
    
      option :no_feedback_msg, "You don't seem to have any feedback."
      option :destroy_msg,     "Feedback deleted."
      option :clear_msg,       "All feedback has been cleared."
      option :redirect,        "/"
    
      add_admin_tab 'Feedback', :controller => "admin/feedback"
    
    end
  end
end

module SiteHasManyFeedbacks
  include_into "Site"
  
  def self.included(base)
    base.has_many :feedbacks, :dependent => :destroy
  end
end