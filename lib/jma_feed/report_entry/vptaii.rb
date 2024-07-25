# 台風の暴風域に入る確率
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 台風の暴風域に入る確率_解説資料.pdf
# 
# STRUCTURE:
# <MeteorologicalInfo type="台風呼称">...</MeteorologicalInfo>
# <MeteorologicalInfo type="台風の暴風域に入る確率（1日積算）">...</MeteorologicalInfo>
# <MeteorologicalInfo type="台風の暴風域に入る確率（2日積算）">...</MeteorologicalInfo>
# <MeteorologicalInfo type="台風の暴風域に入る確率（3日積算）">...</MeteorologicalInfo>
# <MeteorologicalInfo type="台風の暴風域に入る確率（4日積算）">...</MeteorologicalInfo>
# <MeteorologicalInfo type="台風の暴風域に入る確率（5日積算）">...</MeteorologicalInfo>
# <TimeSeriesInfo>...</TimeSeriesInfo>
# 
class JMAFeed::VPTAii < JMAFeed::ReportEntry
  xml_node :body do
    xml_node :meteorological_infos do
      xml_attribute :type
      xml_node_collection :meteorological_info do
        xml_attribute :type
        date_time_node :date_time
        duration_node :duration
        text_node :name
        xml_node_collection :item do
          xml_node :kind do
            xml_node :property do
              text_node :type
              xml_node :typhoon_name_part do
                text_node :name
                text_node :name_kana
                text_node :number
              end
              xml_node :fifty_kt_wind_probability_part do
                integer_node :fifty_kt_wind_probability do
                  xml_attribute :unit
                end
              end
            end
          end
          xml_node :area, type: "JMAFeed::JMX::Area"
        end
      end

      xml_node :time_series_info do
        xml_node :time_defines do
          xml_node_collection :time_define do
            xml_attribute :time_id, with_name: :lower_camelcase
            date_time_node :date_time
            duration_node :duration
            # text_node :name
          end
        end
        xml_node_collection :item do
          xml_node :kind do
            xml_node :property do
              text_node :type
              xml_node :fifty_kt_wind_probability_part do
                integer_node :fifty_kt_wind_probability, collection: true do
                  xml_attribute :unit
                  xml_attribute :ref_id, with_name: "refID"

                  def time_define
                    @time_define ||= parent.parent.parent.parent.parent.time_defines.time_define.find{|d| d.time_id == ref_id}
                  end

                  def date_time
                    time_define&.date_time
                  end

                  def duration
                    time_define&.duration
                  end
                end
              end
            end
          end
          xml_node :area, type: "JMAFeed::JMX::Area"

          def data
            kind.property.fifty_kt_wind_probability_part.fifty_kt_wind_probability
          end
        end
      end
    end

    def info_typhoon
      meteorological_infos.meteorological_info.find{|i| i.type == "台風呼称"}
    end

    def info_probability_within_1day
      meteorological_infos.meteorological_info.find{|i| i.type == "台風の暴風域に入る確率（1日積算）"}
    end

    def info_probability_within_2days
      meteorological_infos.meteorological_info.find{|i| i.type == "台風の暴風域に入る確率（2日積算）"}
    end

    def info_probability_within_3days
      meteorological_infos.meteorological_info.find{|i| i.type == "台風の暴風域に入る確率（3日積算）"}
    end

    def info_probability_within_4days
      meteorological_infos.meteorological_info.find{|i| i.type == "台風の暴風域に入る確率（4日積算）"}
    end

    def info_probability_within_5days
      meteorological_infos.meteorological_info.find{|i| i.type == "台風の暴風域に入る確率（5日積算）"}
    end
  end
end
