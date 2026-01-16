module ProfilesHelper
  def experience_duration(start_date)
    duration = Time.current - start_date
    years = (duration / 1.year).to_i
    months = ((duration % 1.year) / 1.month).to_i

    if years > 0
      "#{years}年#{months}ヶ月"
    else
      "#{months}ヶ月"
    end
  end
end
