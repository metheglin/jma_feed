# jmx_mete
class JMAFeed::JMX::Significancy < Giri::BaseNode
  xml_attribute :type
  text_node :name
  text_node :code
  text_node :condition
end
