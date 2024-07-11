class JMAFeed::JMX::WaterLevel < Giri::TextNode
  xml_attribute :type
  xml_attribute :unit
  xml_attribute :ref_id, with_name: :refID
  xml_attribute :condition
  xml_attribute :description
end