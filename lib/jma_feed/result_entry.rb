class JMAFeed::ResultEntry < Struct.new(
  :title, :id, :updated, :author, :link, :content, keyword_init: true
)
  def identifier
    @identifier ||= id.split('/').last.sub(/\.\w+\z/, '')
  end

  def identifier_components
    time, number, report_code, report_area_code = identifier.split('_')
  end

  def report_code
    @report_code ||= identifier_components[2]
  end

  def report
    return nil if report_code.nil?
    @report ||= JMAFeed::Report.latest.detect{_1.has_code?(report_code)}
  end

  def report_area_code
    @report_area_code ||= identifier_components[3]
  end
end
