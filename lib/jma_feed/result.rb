class JMAFeed::Result
  attr_reader :http_result
  
  def initialize(http_result)
    @http_result = http_result
  end

  def code
    http_result.code
  end

  def body
    http_result.body
  end

  def modified?
    http_result.kind_of?(Net::HTTPSuccess)
  end

  def last_modified
    DateTime.parse(http_result["Last-Modified"])
  end

  def doc
    @doc ||= JMAFeed::ResultDoc.new(body)
  end

  # def namespace
  #   {atom: doc.root.namespace.href}
  # end

  # def text(name)
  #   doc.xpath("/atom:feed/atom:#{name}", namespace).text
  # end

  def title
    doc.title
  end

  def subtitle
    doc.subtitle
  end

  def id
    doc.id
  end

  def updated
    doc.updated
  end

  def related
    doc.related
  end

  def entries
    doc.entries
  end
end
