class JMAFeed::JMX::Visibility < Giri::TextNodeInteger
  xml_attribute :type
  xml_attribute :unit
  xml_attribute :ref_id, with_name: "refID"
  xml_attribute :condition
  xml_attribute :description

  def time_define
    (context.time_define_list || []).find{ref_id && ref_id == _1.time_id}
  end
end