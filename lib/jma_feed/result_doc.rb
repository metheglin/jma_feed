class JMAFeed::ResultDoc
  attr_reader :doc
  
  def initialize(body)
    @body = body
    @doc = Nokogiri::XML(body)
  end

  def namespace
    {atom: doc.root.namespace.href}
  end

  def text(name)
    doc.xpath("/atom:feed/atom:#{name}", namespace).text
  end

  def title
    text('title')
  end

  def subtitle
    text('subtitle')
  end

  def id
    text('id')
  end

  def updated
    DateTime.parse(text('updated'))
  end

  def related
    text('link[@rel="related"]/@href')
  end

  def entries
    @entries ||= doc.xpath('/atom:feed/atom:entry', namespace).map do |entry|
      JMAFeed::ResultEntry.new(
        title: entry.xpath('atom:title', namespace).text,
        link: entry.xpath('atom:link/@href', namespace).text,
        id: entry.xpath('atom:id', namespace).text,
        updated: entry.xpath('atom:updated', namespace).text,
        author: entry.xpath('atom:author/atom:name', namespace).text,
        content: entry.xpath('atom:content', namespace).text,
      )
    end
  end
end