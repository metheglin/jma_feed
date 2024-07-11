require "nokogiri"
require "giri"

class JMAFeed::ReportEntry < Giri::BaseNode
  class << self
    def get(url)
      xml = Net::HTTP.get(URI.parse(url))
      doc = Nokogiri::XML(xml)
      new(doc.root)
    end
  end

  xml_node :control do
    text_node :title
    date_time_node :date_time
    text_node :status
    text_node :editorial_office
    text_node :publishing_office
  end
  xml_node :head do
    text_node :title
    date_time_node :report_date_time
    date_time_node :target_date_time
    text_node :target_duration
    text_node :info_type
    text_node :info_kind
    text_node :info_kind_version
  end
end

require "jma_feed/report_entry/jmx/area"
require "jma_feed/report_entry/jmx/significancy"
require "jma_feed/report_entry/vprn50"
require "jma_feed/report_entry/vpww54"
require "jma_feed/report_entry/vxko"
