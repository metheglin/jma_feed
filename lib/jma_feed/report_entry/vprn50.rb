# 大雨危険度通知
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 大雨危険度通知_解説資料.pdf
# 
# STRUCTURE:
# <MeteorologicalInfos type="区域予報"> # 府県予報区
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度分布
# </MeteorologicalInfos>
# <MeteorologicalInfos type="区域予報"> # 一次細分区域
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度分布
# </MeteorologicalInfos>
# <MeteorologicalInfos type="区域予報"> # 市町村などをまとめた地域
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度分布
# </MeteorologicalInfos>
# <MeteorologicalInfos type="区域予報"> # 二時細分区域およびさらに詳細な区域
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度
#   <MeteorologicalInfo>...</MeteorologicalInfo> # 危険度分布
# </MeteorologicalInfos>
# 
# 危険度: 注意報・警報、土砂災害警戒情報、指定河川洪水予報、早期注意情報、危険度分布の発表状況を考慮した対象地域内の危険度
# 危険度分布: 危険度分布を指標とした危険度 https://www.jma.go.jp/jma/kishou/know/bosai/riskmap.html
class JMAFeed::VPRN50 < JMAFeed::ReportEntry

  # AREA_TYPES = {
  #   district_forecast: "府県予報区",
  #   district_1st: "一次細分区域",
  #   district_aggregated: "市町村等をまとめた地域",
  #   district_2nd: "二次細分区域及びさらに詳細な区域",
  # }

  # RISK_TYPES = {
  #   heavy_rain: "大雨危険度",
  #   landslide: "土砂災害危険度",
  #   submerge: "浸水害危険度",
  #   flood: "洪水害危険度",
  # }

  xml_node :body do
    xml_node_collection :meteorological_infos do
      xml_node_collection :meteorological_info do
        date_time_node :date_time
        xml_node_collection :item do
          xml_node :kind do
            xml_node :property do
              text_node :type
              xml_node :significancy_part do
                xml_node :base do
                  xml_node_collection :significancy, type: "JMAFeed::JMX::Significancy"
                end
              end
            end
          end
          xml_node :area, type: "JMAFeed::JMX::Area"

          def type
            kind&.property&.type
          end

          def significancies
            kind&.property&.significancy_part&.base&.significancy || []
          end

          def heavy_rain
            significancies.find{|s| s.type == "大雨危険度"}
          end

          def landslide
            significancies.find{|s| s.type == "土砂災害危険度"}
          end

          def submerge
            significancies.find{|s| s.type == "浸水害危険度"}
          end

          def flood
            significancies.find{|s| s.type == "洪水害危険度"}
          end
        end
      end
    end

    def info_district_forecast
      meteorological_infos[0].meteorological_info[0]
    end

    def info_district_1st
      meteorological_infos[1].meteorological_info[0]
    end

    def info_district_aggregated
      meteorological_infos[2].meteorological_info[0]
    end

    def info_district_2nd
      meteorological_infos[3].meteorological_info[0]
    end
  end
end
