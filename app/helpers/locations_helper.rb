module LocationsHelper
  def zip_format?(str)
    ('A'..'Z').each do |ltr|
      str.gsub!(ltr, '')
      str.gsub!(ltr.downcase, '')
    end
    str.length == 5
  end
end
