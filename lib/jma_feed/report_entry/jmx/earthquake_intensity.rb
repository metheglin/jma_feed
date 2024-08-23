class JMAFeed::JMX::EarthquakeIntensity < Giri::TextNodeString
  # self:
  # 1, 2, 3, 4, 5-, 5+, 6-, 6+, 7, 震度5弱以上未入電

  def intensity
    value = self.sub(/\-\z/, '').sub(/\+\z/, '.5').to_f
    value > 0 ? value : nil
  end

  def title
    return self unless intensity
    "震度" + self.sub(/\-\z/, '弱').sub(/\+\z/, '強')
  end
end