class JMAFeed::JMX::TimeDefine < Giri::BaseNode
  xml_attribute :time_id, with_name: :lower_camelcase
  date_time_node :date_time
  duration_node :duration
  text_node :name

  def start_at
    date_time
  end

  def end_at
    start_at + duration.duration_time
  end

  def to_h
    {name: name, start_at: start_at, end_at: end_at, duration: duration}
  end
end