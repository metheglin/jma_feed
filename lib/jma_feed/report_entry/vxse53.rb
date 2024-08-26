# 地震情報（震源・震度に関する情報）
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 地震火山関連_解説資料.pdf > (ウ)地震情報(震源・震度に関する情報)
# 
class JMAFeed::VXSE53 < JMAFeed::ReportEntry
  xml_node :head do
    text_node :event_id, with_name: "EventID"
  end

  xml_node :body do
    xml_node :earthquake, type: "JMAFeed::JMX::Earthquake"

    xml_node :intensity do
      xml_node :observation do
        xml_node :code_define do
          text_node :type, collection: true do
            xml_attribute :xpath
          end
        end

        text_node :max_int

        xml_node_collection :pref do
          text_node :name
          text_node :code
          xml_node :max_int, type: "JMAFeed::JMX::EarthquakeIntensity"
          text_node :revise
          xml_node_collection :area do
            text_node :name
            text_node :code
            xml_node :max_int, type: "JMAFeed::JMX::EarthquakeIntensity"
            text_node :revise
            xml_node_collection :city do
              text_node :name
              text_node :code
              xml_node :max_int, type: "JMAFeed::JMX::EarthquakeIntensity"
              text_node :revise
              text_node :condition
              xml_node_collection :intensity_station do
                text_node :name
                text_node :code
                xml_node :int, type: "JMAFeed::JMX::EarthquakeIntensity"
                text_node :revise
              end
            end
          end
        end
      end
    end

    xml_node :comments do
      xml_node :forecast_comment do
        xml_attribute :code_type
        text_node :text
        text_node :code
      end
      xml_node :var_comment do
        xml_attribute :code_type
        text_node :text
        text_node :code
      end
      xml_node :free_form_comment do
        text_node :text
      end
    end
  end

  def detect_with_area(area)
    pref = detect_pref_with_area(area)
    return nil unless pref

    earthquake = body.earthquake
    comments = [
      body.comments&.forecast_comment&.text,
      body.comments&.var_comment&.text,
      body.comments&.free_form_comment&.text,
    ].compact
    if area.is_a?(JMACode::Prefecture)
      AreaAlert.new(entry: self, area: area, intensity: pref, earthquake: earthquake, comments: comments)
    else
      local_area = detect_local_area_with_area(area, pref)
      if local_area && area.is_a?(JMACode::AreaForecastLocalE)
        AreaAlert.new(entry: self, area: area, intensity: local_area, earthquake: earthquake, comments: comments)
      else
        city = detect_city_with_area(area, local_area)
        if city && area.is_a?(JMACode::AreaInformationCity)
          AreaAlert.new(entry: self, area: area, intensity: city, earthquake: earthquake, comments: comments)
        end
      end
    end
  end

  def detect_pref_with_area(area)
    intensity = body.intensity
    return nil unless intensity
    
    prefs = intensity.observation.pref
    pref_code = if area.is_a?(JMACode::Prefecture)
      area.code
    elsif area.is_a?(JMACode::AreaForecastLocalE)
      area.prefecture_code
    elsif area.is_a?(JMACode::AreaInformationCity)
      area.prefecture_code
    else
      nil
    end

    prefs.find{|pr| pr.code == pref_code}
  end

  def detect_local_area_with_area(area, pref_node)
    area_code = if area.is_a?(JMACode::AreaForecastLocalE)
      area.code
    elsif area.is_a?(JMACode::AreaInformationCity)
      area.area_forecast_local_e_code
    else
      nil
    end

    pref_node.area.find{|ar| ar.code == area_code}
  end

  def detect_city_with_area(area, local_area_node)
    city_code = if area.is_a?(JMACode::AreaInformationCity)
      area.code
    else
      nil
    end

    local_area_node.city.find{|c| c.code == city_code}
  end

  class AreaAlert < Struct.new(:entry, :area, :intensity, :earthquake, :comments, keyword_init: true)
  end
end
