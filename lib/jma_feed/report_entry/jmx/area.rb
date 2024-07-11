# jmx_ib
class JMAFeed::JMX::Area < Giri::BaseNode
  xml_attribute :code_type, with_name: :lower_camelcase

  text_node :name
  text_node :code
end
