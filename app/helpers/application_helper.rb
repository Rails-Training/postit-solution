module ApplicationHelper
  def fix_url(url)
    url.starts_with?("http://") ? url : "http://#{url}"
  end
  
  def display_datettime(dt)
    dt = dt.in_time_zone(current_user.time_zone) if logged_in? and !current_user.time_zone.blank?
    dt.strftime('%m/%d/%Y %l:%M%P %Z') # 09/23/2014 12:43pm
  end
end
