class JapanTime

  def getJTime
    return "oyasumi" if Time.now.to_i < Time.parse("06:00").to_i
    return "ohayou" if Time.now.to_i < Time.parse("12:00").to_i
    return "konichiwa" if Time.now.to_i < Time.parse("18:00").to_i
    return "konbanwa" if Time.now.to_i < Time.parse("23:59").to_i
  end

end
