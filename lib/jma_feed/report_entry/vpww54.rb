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
    text_node :notice, collection: true
    xml_node_collection :warning do
      xml_attribute :type
      xml_node_collection :item do
        xml_node_collection :kind do
          text_node :name
          text_node :code
          text_node :status
          text_node :condition
          xml_node :last_kind do
            text_node :name
            text_node :code
          end
          xml_node_collection :next_kinds do
            xml_node :next_kind do
              text_node :name
              text_node :code
              date_time_node :date_time do
                xml_attribute :precision, type: :duration
              end
              text_node :sentence
            end
          end
          xml_node :attention do
            text_node :note, collection: true
          end
          xml_node :addition do
            text_node :note, collection: true
          end

          def weather_alert
            @weather_alert ||= JMAFeed::WeatherAlert.all.find{|a| a.code == code}
          end
        end
        text_node :change_status
        xml_node :area, type: "JMAFeed::JMX::Area"

        JMAFeed::WeatherAlert.clusters.each do |cluster,alerts|
          define_method cluster do
            kind.find{|k| alerts.map(&:code).include?(k.code)}
          end
        end
      end
    end

    xml_node :meteorological_infos do
      xml_attribute :type
      xml_node :time_series_info do
        context :time_define_list do
          time_defines.time_define
        end

        xml_node :time_defines do
          xml_node_collection :time_define do
            xml_attribute :time_id, with_name: :lower_camelcase
            date_time_node :date_time
            duration_node :duration
            text_node :name
          end
        end
        xml_node_collection :item do
          xml_node_collection :kind do
            text_node :name
            text_node :code
            text_node :condition
            xml_node_collection :property do
              text_node :type

              JMAFeed::WeatherAlert.metrics_components.each do |metr_component|
                xml_node_collection "#{metr_component[:name]}_part".to_sym do
                  xml_node :base do
                    xml_node_collection metr_component[:name], type: "JMAFeed::JMX::#{metr_component[:name].to_s.camelize}"

                    xml_node_collection :local do
                      text_node :area_name
                      xml_node_collection metr_component[:name], type: "JMAFeed::JMX::#{metr_component[:name].to_s.camelize}"
                    end
                  end
                end
              end
            end

            def weather_alert
              @weather_alert ||= JMAFeed::WeatherAlert.all.find{|a| a.code == code}
            end

            # EXAMPLE of data structure
            # {
            #   "土砂災害危険度" => [...],
            #   "浸水害危険度" => [...],
            #   "1時間最大雨量" => [...],
            #   "3時間最大雨量" => [...],
            # }
            # or 
            # {
            #   "土砂災害危険度" => {"山地" => [...], "平地" => [...]},
            #   "浸水害危険度" => {"山地" => [...], "平地" => [...]},
            #   "1時間最大雨量" => {"山地" => [...], "平地" => [...]},
            #   "3時間最大雨量" => {"山地" => [...], "平地" => [...]},
            # }
            def weather_alert_metrics
              return nil unless weather_alert
              weather_alert.metrics.map do |k,v|
                metrics_part = property.find{_1.type == v[:property_type]}&.public_send("#{v[:name]}_part")
                metrics_bases = metrics_part&.map(&:base)
                metrics_items = if metrics_bases && metrics_bases.length > 0
                  primary_base = metrics_bases.first
                  if primary_base.local && primary_base.local.length > 0
                    metrics_bases.map{[_1.local.area_name, _1.local.public_send(v[:name])]}.to_h
                  else
                    metrics_bases.first.public_send(v[:name])
                  end
                else
                  nil
                end

                if metrics_items
                  [k, metrics_items]
                else
                  nil
                end
              end.to_h
            end
          end

          JMAFeed::WeatherAlert.clusters.each do |cluster,alerts|
            define_method cluster do
              kind.find{|k| alerts.map(&:code).include?(k.code)}
            end
          end

          xml_node :area, type: "JMAFeed::JMX::Area"
        end
      end
    end

    def warning_area_type1
      warning.find{|w| w.type == "気象警報・注意報（府県予報区等）"}
    end

    def warning_area_type2
      warning.find{|w| w.type == "気象警報・注意報（一次細分区域等）"}
    end

    def warning_area_type3
      warning.find{|w| w.type == "気象警報・注意報（市町村等をまとめた地域等）"}
    end

    def warning_area_type4
      warning.find{|w| w.type == "気象警報・注意報（市町村等）"}
    end
  end

  def detect_with_area(area, weather_alert_clusters: nil)
    weather_alert_clusters ||= JMAFeed::WeatherAlert.clusters.keys
    warning_item = detect_warning_item_with_area(area)
    return AreaDetecter.new unless warning_item

    warning_alerts = weather_alert_clusters.map{|cluster|
      warning_item.public_send(cluster)
    }.compact

    info_item = detect_info_item_with_area(area)
    info_alerts = info_item && weather_alert_clusters.map{|cluster|
      info_item.public_send(cluster)
    }.compact

    AreaDetecter.new(warning_alerts: warning_alerts, info_alerts: info_alerts)
  end

  def detect_warning_item_with_area(area)
    items = if area.is_a?(JMACode::AreaInformationCity)
      body.warning_area_type4.item
    else
      if area.used_by.include?("area_forecast_type3_in_weather_alert")
        body.warning_area_type3.item
      elsif area.used_by.include?("area_forecast_type2_in_weather_alert")
        body.warning_area_type2.item
      elsif area.used_by.include?("area_forecast_type1_in_weather_alert")
        body.warning_area_type1.item
      else
        nil
      end
    end
    items&.find{_1.area.code == area.code}
  end

  def detect_info_item_with_area(area)
    if area.is_a?(JMACode::AreaInformationCity)
      body.meteorological_infos.time_series_info.item.find{_1.area.code == area.code}
    else
      nil
    end
  end

  class AreaDetecter < Struct.new(:warning_alerts, :info_alerts, keyword_init: true)
  end
end
