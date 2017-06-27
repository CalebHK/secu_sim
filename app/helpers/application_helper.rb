module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "SecuSim by CalebHK"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def hk_today_midnight
    Date.today.midnight.in_time_zone("Hong Kong").utc
  end
  
  def hk_tmr_midnight
    hk_today_midnight + 1.day
  end
end
