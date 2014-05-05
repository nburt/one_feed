class TimeFormatter

  def initialize(time)
    @time = time
  end

  def format
    if Time.at(Time.now - @time).strftime('%-M') == "0"
      "Just now"
    else
      "#{Time.at(Time.now - @time).strftime('%-M')} minutes ago"
    end
  end

end