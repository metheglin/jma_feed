# 指定河川洪水予報
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 指定河川洪水予報_解説資料.pdf
#
class JMAFeed::VXKO < JMAFeed::ReportEntry

  xml_node :head do
    xml_node :headline do
      text_node :text
      xml_node_collection :information do
        xml_attribute :type
        xml_node :item do
          xml_node :kind do
            text_node :name
            text_node :code
            text_node :condition
          end
          xml_node :areas do
            xml_attribute :code_type
            xml_node_collection :area do
              text_node :name
              text_node :code
            end
          end
        end
      end

      def info_river_district
        information.find{|i| i.type == "指定河川洪水予報（予報区域）"}&.item
      end

      def info_river
        information.find{|i| i.type == "指定河川洪水予報（河川）"}&.item
      end

      def info_district_forecast
        information.find{|i| i.type == "指定河川洪水予報（府県予報区等）"}&.item
      end
    end
  end

  xml_node :body do
    text_node :notice
    xml_node :warning do
      xml_attribute :type
      xml_node_collection :item do
        xml_node :kind do
          text_node :name
          text_node :code
          text_node :status
          xml_node :property do
            text_node :type
            text_node :text
          end
        end
        xml_node :areas do
        end
        xml_node :stations do
        end

        def type
          kind&.property&.type
        end
      end
    end

    def warning_sentence
      warning.item.select{|i| i.type == "主文"}
    end

    def warning_inundation_expected
      warning.item.select{|i| i.type == "浸水想定地区"}
    end

    def warning_inundation_happening
      warning.item.select{|i| i.type == "浸水想定地区(氾濫発生情報)"}
    end

    xml_node_collection :meteorological_infos do
      xml_attribute :type
      xml_node :meteorological_info do
        date_time_node :date_time
        xml_node :item do
          xml_node :kind do
            text_node :name
            xml_node :property do
              text_node :type
              text_node :text
            end
          end
          xml_node :area, type: "JMAFeed::JMX::Area"

          def type
            kind&.property&.type
          end
        end
      end
      xml_node :time_series_info do
        xml_node :time_defines do
          xml_node_collection :time_define do
            xml_attribute :time_id
            date_time_node :date_time
            duration_node :duration
            text_node :name
          end
        end

        xml_node_collection :item do
          xml_node :kind do
            text_node :name
            xml_node :property do
              text_node :type
              xml_node :precipitation_part do
                xml_node_collection :precipitation, type: "JMAFeed::JMX::Precipitation" do
                  def time_define_list
                    parent.parent.parent.parent.parent.time_defines.time_define
                  end

                  def time_define
                    time_define_list.find{|d| d.time_id == ref_id}
                  end
                end
              end
              xml_node :water_level_part do
                xml_node_collection :water_level, type: "JMAFeed::JMX::WaterLevel"
              end
              xml_node :discharge_part do
                xml_node_collection :discharge, type: "JMAFeed::JMX::Discharge"
              end
            end
          end
          xml_node :area do
            text_node :name
          end
          xml_node :station do
            text_node :name
            text_node :code
            text_node :location
          end

          def precipitation
            kind&.property&.precipitation_part&.precipitation
          end

          def water_level
            kind&.property&.water_level_part&.water_level
          end
        end
      end
    end

    def info_precipitation
      meteorological_infos.find{|i| i.type == "雨量情報"}
    end

    def info_water_level
      meteorological_infos.find{|i| i.type == "水位・流量情報"}
    end

    def info_flood
      meteorological_infos.find{|i| i.type == "氾濫水の予報"}
    end

    def time_series_precipitation
      info_precipitation.time_series_info.item.first
    end

    def time_series_water_level
      info_water_level.time_series_info.item.first
    end

    def time_series_flood
      info_flood.time_series_info.item.first
    end
  end
end
