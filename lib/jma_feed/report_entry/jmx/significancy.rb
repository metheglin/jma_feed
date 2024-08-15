# jmx_mete
class JMAFeed::JMX::Significancy < Giri::BaseNode
  xml_attribute :type
  xml_attribute :ref_id, with_name: "refID"
  text_node :name
  text_node :code
  text_node :condition

  def time_define
    (context.time_define_list || []).find{ref_id && ref_id == _1.time_id}
  end

  def metrics_item
    @metrics_item ||= JMAFeed::WeatherAlert::MetricsItem.new(
      name: type,
      value: code,
      description: name,
      time_define: time_define,
    )
  end
end
