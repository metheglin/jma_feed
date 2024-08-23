require "giri"
# require "active_support/inflector"

module JMAFeed
  module JMX
  end
end

require "jma_feed/version"
require "jma_feed/report"
require "jma_feed/result"
require "jma_feed/result_doc"
require "jma_feed/result_entry"
require "jma_feed/atom"
require "jma_feed/atom/extra"
require "jma_feed/atom/regular"
require "jma_feed/atom/eqvol"
require "jma_feed/atom/other"
require "jma_feed/node/base_node"
require "jma_feed/entity/weather_alert"
require "jma_feed/entity/weather_alert/metrics_item"
require "jma_feed/entity/risk_level"

require "jma_feed/report_entry"

