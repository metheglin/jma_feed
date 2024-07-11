class JMAFeed::Alert < Struct.new(:code, :name, :risk_level, :cluster, keyword_init: true)
  # 気象警報・注意（Ｈ２７）_解説資料.pdf > 別表1
  # https://www.jma.go.jp/jma/kishou/know/bosai/warning_kind.html
  LIST = {
    "00" => {
      name: "解除",
      risk_level: :level5,
      cluster: :clear,
    },
    "02" => {
      name: "暴風雪警報",
      risk_level: :level3,
      cluster: :snowstorm,
    },
    "03" => {
      name: "大雨警報",
      risk_level: :level3,
      cluster: :heavy_rain,
    },
    "04" => {
      name: "洪水警報",
      risk_level: :level3,
      cluster: :flood,
    },
    "05" => {
      name: "暴風警報",
      risk_level: :level3,
      cluster: :storm,
    },
    "06" => {
      name: "大雪警報",
      risk_level: :level3,
      cluster: :heavy_snow,
    },
    "07" => {
      name: "波浪警報",
      risk_level: :level3,
      cluster: :high_wave,
    },
    "08" => {
      name: "高潮警報",
      risk_level: :level3,
      cluster: :storm_surge,
    },
    "10" => {
      name: "大雨注意報",
      risk_level: :level2,
      cluster: :heavy_rain,
    },
    "12" => {
      name: "大雪注意報",
      risk_level: :level2,
      cluster: :heavy_snow,
    },
    "13" => {
      name: "風雪注意報",
      risk_level: :level2,
      cluster: :snowstorm,
    },
    "14" => {
      name: "雷注意報",
      risk_level: :level2,
      cluster: :thunderstorm,
    },
    "15" => {
      name: "強風注意報",
      risk_level: :level2,
      cluster: :storm,
    },
    "16" => {
      name: "波浪注意報",
      risk_level: :level2,
      cluster: :high_wave,
    },
    "17" => {
      name: "融雪注意報",
      risk_level: :level2,
      cluster: :snow_melting,
    },
    "18" => {
      name: "洪水注意報",
      risk_level: :level2,
      cluster: :flood,
    },
    "19" => {
      name: "高潮注意報",
      risk_level: :level2,
      cluster: :storm_surge,
    },
    "20" => {
      name: "濃霧注意報",
      risk_level: :level2,
      cluster: :dense_fog,
    },
    "21" => {
      name: "乾燥注意報",
      risk_level: :level2,
      cluster: :dry_air,
    },

    "22" => {
      name: "なだれ注意報",
      risk_level: :level2,
      cluster: :avalanche,
    },
    "23" => {
      name: "低温注意報",
      risk_level: :level2,
      cluster: :low_temperature,
    },
    "24" => {
      name: "霜注意報",
      risk_level: :level2,
      cluster: :frost,
    },
    "25" => {
      name: "着氷注意報",
      risk_level: :level2,
      cluster: :ice_accretion,
    },
    "26" => {
      name: "着雪注意報",
      risk_level: :level2,
      cluster: :snow_accretion,
    },
    "27" => {
      name: "その他の注意",
      risk_level: :level2,
      cluster: :other,
    },

    "32" => {
      name: "暴風雪特別警報",
      risk_level: :level5,
      cluster: :snowstorm,
    },
    "33" => {
      name: "大雨特別警報",
      risk_level: :level5,
      cluster: :heavy_rain,
    },
    "35" => {
      name: "暴風特別警報",
      risk_level: :level5,
      cluster: :storm,
    },
    "36" => {
      name: "大雪特別警報",
      risk_level: :level5,
      cluster: :heavy_snow,
    },
    "37" => {
      name: "波浪特別警報",
      risk_level: :level5,
      cluster: :high_wave,
    },
    "38" => {
      name: "高潮特別警報",
      risk_level: :level5,
      cluster: :storm_surge,
    },
  }

  # def self.clusters
  #   LIST.map{|k,v| v[:cluster]}.uniq
  # end

  def self.clusters
    # LIST.map{|k,v| v[:cluster]}.uniq
    all.group_by(&:cluster)
  end

  def self.all
    @all ||= LIST.map{|k,v| new(v.merge(code: k.to_s))}
  end
end
