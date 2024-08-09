require "net/http"

module JMAFeed::Api

  def self.type(feed_type, **args)
    feed_type = feed_type.to_sym
    if feed_type == :regular
      JMAFeed::Regular.new(**args)
    elsif feed_type == :extra
      JMAFeed::Extra.new(**args)
    else
      raise "feed_type=#{feed_type} not supported"
    end
  end

  def get(if_modified_since: nil, &block)
    res = execute(:get, "https://www.data.jma.go.jp/developer/xml/feed/#{feed_type}.xml", headers: {
      "If-Modified-Since" => if_modified_since ? 
        if_modified_since.httpdate :
        nil
    }, &block)
    JMAFeed::Result.new(res)
  end

  # def get_feed_regular(if_modified_since: nil, &block)
  #   res = execute(:get, "https://www.data.jma.go.jp/developer/xml/feed/regular.xml", headers: {
  #     "If-Modified-Since" => if_modified_since ? 
  #       if_modified_since.httpdate :
  #       nil
  #   }, &block)
  #   JMAFeed::Result.new(res)
  # end

  # def get_feed_extra(if_modified_since: nil, &block)
  #   res = execute(:get, "https://www.data.jma.go.jp/developer/xml/feed/extra.xml", headers: {
  #     "If-Modified-Since" => if_modified_since ? 
  #       if_modified_since.httpdate :
  #       nil
  #   }, &block)
  #   JMAFeed::Result.new(res)
  # end

  def execute(verb, uri, query: nil, body: nil, headers: {})
    uri = uri.is_a?(URI::HTTP) ? uri : URI.parse(uri)
    request = build_request(verb, uri, query: query, body: body)
    headers.each {|k,v| request[k] = v}
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      yield(request, http) if block_given?
      # http.read_timeout = 30 # sec
      http.request(request)
    end
  end

  def build_request(verb, uri, query: nil, body: nil, headers: {})
    if query
      uri.query = URI.encode_www_form(query)
    end
    request = "Net::HTTP::#{verb.to_s.camelize}".constantize.new(uri)
    
    if body
      request.body = body
    end
    
    request
  end
end
