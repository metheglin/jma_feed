class JMAFeed::WeatherAlert::MetricsItem < Struct.new(
  :name, :value, :description, :time_define,
  keyword_init: true
)

  def to_h
    {
      name: name,
      value: value,
      description: description,
      time_define: time_define.to_h,
    }
  end
end
