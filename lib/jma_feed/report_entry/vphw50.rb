# 気象警報・注意報（Ｈ２７）
# https://xml.kishou.go.jp/tec_material.html
# 電文毎の解説資料 > 解説資料セットzip > 竜巻注意情報_解説資料.pdf
# 
# STRUCTURE:
# <Warning type="竜巻注意情報（発表細分）">...</Warning>
# <Warning type="竜巻注意情報（一次細分区域等）">...</Warning>
# <Warning type="竜巻注意情報（市町村等をまとめた地域等）">...</Warning>
# <Warning type="竜巻注意情報（市町村等）">...</Warning>
# 
class JMAFeed::VPHW50 < JMAFeed::ReportEntry
  xml_node :body do
    xml_node_collection :warning do
      xml_attribute :type
      xml_node_collection :item do
        xml_node_collection :kind do
          text_node :name
          text_node :code
          text_node :status
        end
        xml_node :area, type: "JMAFeed::JMX::Area"
      end
    end

    def warning_district_report
      warning.find{|w| w.type == "竜巻注意情報（発表細分）"}
    end

    def warning_district_1st
      warning.find{|w| w.type == "竜巻注意情報（一次細分区域等）"}
    end

    def warning_district_aggregated
      warning.find{|w| w.type == "竜巻注意情報（市町村等をまとめた地域等）"}
    end

    def warning_district_2nd
      warning.find{|w| w.type == "竜巻注意情報（市町村等）"}
    end
  end
end
