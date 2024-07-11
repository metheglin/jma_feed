# 気象警報・注意報（Ｈ２７）
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 気象警報・注意報（Ｈ２７）_解説資料.pdf
# 
# STRUCTURE:
# <Warning type="気象警報・注意報（府県予報区等）">...</Warning>
# <Warning type="気象警報・注意報（一次細分区域等）">...</Warning>
# <Warning type="気象警報・注意報（市町村等をまとめた地域等）">...</Warning>
# <Warning type="気象警報・注意報（市町村等）">...</Warning>
# <MeteorologicalInfos type="量的予想時系列（市町村等）">
# </MeteorologicalInfos>
# 
class JMAFeed::VPWW54 < JMAFeed::ReportEntry
  xml_node :body do
    xml_node_collection :warning do
      xml_attribute :type
      xml_node_collection :item do
        xml_node_collection :kind do
          text_node :name
          text_node :code
          text_node :status
          text_node :condition
          xml_node :attention do
            text_node :note, collection: true
          end
          xml_node :addition do
            text_node :note, collection: true
          end

          def alert
            @alert ||= JMAFeed::Alert.all.find{|a| a.code == code}
          end
        end
        text_node :change_status
        xml_node :area, type: "JMAFeed::JMX::Area"

        JMAFeed::Alert.clusters.each do |cluster,alerts|
          define_method cluster do
            kind.find{|k| alerts.map(&:code).include?(k.code)}
          end
        end
      end
    end
    xml_node :meteorological_infos do
      xml_attribute :type
      xml_node :time_series_info do
        xml_node :time_defines do
          xml_node_collection :time_define do
            xml_attribute :time_id, with_name: :lower_camelcase
            date_time_node :date_time
            duration_node :duration
            text_node :name
          end
        end
        xml_node_collection :item do
          # TODO
        end
      end
    end

    def warning_district_forecast
      warning[0]
    end

    def warning_district_1st
      warning[1]
    end

    def warning_district_aggregated
      warning[2]
    end

    def warning_district_2nd
      warning[3]
    end
  end
end
