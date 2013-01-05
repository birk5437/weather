class SiteController < ApplicationController
  #skip_before_filter :check_authentication, :login_required

  layout nil
  def index
    if logged_in?
      redirect_to(dashboard_path)
    else
      redirect_to(login_path)
    end
  end
end
