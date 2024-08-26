# jmx_eb
class JMAFeed::JMX::Earthquake < Giri::BaseNode
  date_time_node :origin_time
  date_time_node :arrival_time

  xml_node :hypocenter do
    xml_node :area do
      text_node :name
      text_node :code do
        xml_attribute :type
      end
      text_node :coordinate do
        text_node :description
        text_node :datum
      end
    end
  end
  big_decimal_node :magnitude do
    xml_attribute :type
    xml_attribute :description
  end
end
