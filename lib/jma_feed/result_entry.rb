class JMAFeed::ResultEntry < Struct.new(
  :title, :id, :updated, :author, :link, :content, keyword_init: true
)
  def report_code
    @report_code ||= id.split('/').last.split('_')[2]
  end

  def report
    return nil if report_code.nil?
    @report ||= JMAFeed::Report.latest.detect{_1.has_code?(report_code)}
  end
end
