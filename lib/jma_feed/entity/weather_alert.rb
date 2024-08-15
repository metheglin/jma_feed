class JMAFeed::WeatherAlert < Struct.new(:code, :name, :risk_level, :cluster, keyword_init: true)
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

  # 気象警報・注意（Ｈ２７）_解説資料.pdf > 別表４
  METRICS = {
    storm_metrics: {
      "風危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "風向" => {
        name: :wind_direction,
        property_type: "風",
      },
      "最大風速" => {
        name: :wind_speed,
        property_type: "風",
      },
    },
    rain_metrics: {
      "土砂災害危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "浸水害危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "1時間最大雨量" => {
        name: :precipitation,
        property_type: "雨",
      },
      "3時間最大雨量" => {
        name: :precipitation,
        property_type: "雨",
      },
    },
    flood_metrics: {
      "洪水害危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    snow_metrics: {
      "雪危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "6時間最大降雪量" => {
        name: :snow_fall_depth,
        property_type: "雪",
      },
      "12時間最大降雪量" => {
        name: :snow_fall_depth,
        property_type: "雪",
      },
      "24時間最大降雪量" => {
        name: :snow_fall_depth,
        property_type: "雪",
      },
    },
    wave_metrics: {
      "波危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "波高" => {
        name: :wave_height,
        property_type: "波",
      },
    },
    tide_metrics: {
      "高潮危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "最高潮位" => {
        name: :tidal_level,
        property_type: "高",
      },
    },
    thunder_metrics: {
      "雷危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    snow_melting_metrics: {
      "融雪危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    fog_metrics: {
      "濃霧危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "視程" => {
        name: :visibility,
        property_type: "濃霧",
      },
    },
    dry_air_metrics: {
      "乾燥危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
      "実効湿度" => {
        name: :humidity,
        property_type: "乾燥",
      },
      "最小湿度" => {
        name: :humidity,
        property_type: "乾燥",
      },
    },
    avalanche_metrics: {
      "なだれ危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    low_temperature_metrics: {
      "低温危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    frost_metrics: {
      "霜危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    ice_accretion_metrics: {
      "着氷危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
    snow_accretion_metrics: {
      "着雪危険度" => {
        name: :significancy,
        property_type: "危険度",
      },
    },
  }

  CLUSTER_METRICS = {
    storm: METRICS[:storm_metrics],
    snowstorm: METRICS[:storm_metrics],
    heavy_rain: METRICS[:rain_metrics],
    flood: METRICS[:flood_metrics],
    heavy_snow: METRICS[:snow_metrics],
    high_wave: METRICS[:wave_metrics],
    storm_surge: METRICS[:tide_metrics],
    thunderstorm: METRICS[:thunder_metrics],
    snow_melting: METRICS[:snow_melting_metrics],
    dense_fog: METRICS[:fog_metrics],
    dry_air: METRICS[:dry_air_metrics],
    avalanche: METRICS[:avalanche_metrics],
    low_temperature: METRICS[:low_temperature_metrics],
    frost: METRICS[:frost_metrics],
    ice_accretion: METRICS[:ice_accretion_metrics],
    snow_accretion: METRICS[:snow_accretion_metrics],
  }

  def self.clusters
    all.group_by(&:cluster)
  end

  def self.all
    @all ||= LIST.map{|k,v| new(v.merge(code: k.to_s))}
  end

  def self.metrics_properties
    METRICS.values.reduce(&:merge)
  end

  def self.metrics_components
    metrics_properties.values.uniq
  end

  def metrics
    CLUSTER_METRICS[cluster.to_sym] || {}
  end
end
