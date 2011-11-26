module PagesHelper

  def get_time
    require 'japan_time'
    return JapanTime.new.getJTime
  end
end
