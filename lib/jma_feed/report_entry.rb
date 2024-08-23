require "nokogiri"

class JMAFeed::ReportEntry < JMAFeed::BaseNode
  class << self
    def get(url)
      xml = Net::HTTP.get(URI.parse(url))
      build(xml)
    end

    def build(xml)
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
    xml_node :headline do
      text_node :text
    end
  end
end

require "jma_feed/report_entry/jmx/area"
require "jma_feed/report_entry/jmx/time_define"
require "jma_feed/report_entry/jmx/significancy"
require "jma_feed/report_entry/jmx/precipitation"
require "jma_feed/report_entry/jmx/water_level"
require "jma_feed/report_entry/jmx/discharge"
require "jma_feed/report_entry/jmx/wind_direction"
require "jma_feed/report_entry/jmx/wind_speed"
require "jma_feed/report_entry/jmx/wave_height"
require "jma_feed/report_entry/jmx/visibility"
require "jma_feed/report_entry/jmx/snow_fall_depth"
require "jma_feed/report_entry/jmx/humidity"
require "jma_feed/report_entry/jmx/tidal_level"
require "jma_feed/report_entry/jmx/earthquake"
require "jma_feed/report_entry/jmx/earthquake_intensity"
require "jma_feed/report_entry/vprn50"
require "jma_feed/report_entry/vpww54"
require "jma_feed/report_entry/vxko"
require "jma_feed/report_entry/vphw50"
require "jma_feed/report_entry/vptaii"
require "jma_feed/report_entry/vxse53"
