class JMAFeed::ResultEntry < Struct.new(
  :title, :id, :updated, :author, :link, :content, keyword_init: true
)
  def identifier
    @identifier ||= id.split('/').last.sub(/\.\w+\z/, '')
  end

  def identifier_components
    time, number, report_code, report_area_code = identifier.split('_')
  end

  # 気象警報・注意報（Ｈ２７）_解説資料.pdf
  # ---------------
  # 「前回電文」とは、参照中の電文(当該電文)と、
  # - 情報名称(Control/Title)
  # - 運用種別(Control/Status)
  # - 発信官署(Control/EditorialOffice)
  # が同一である電文の中で、発表時刻(Head/ReportDateTime)が当該電文の直近過去である電文を指す。
  # 
  # idに記載されるファイル名アンダースコア区切りの2番目がStatusを意味しているのかどうかは2024Aug時点で不明
  # Status="通常" の電文しか取得できておらず確証はないが、この値をidに含んでいる可能性が高いと見切っての実装
  def identity
    [report_code, report_status, report_area_code].join('_')
  end

  def report_code
    @report_code ||= identifier_components[2]
  end

  def report
    return nil if report_code.nil?
    @report ||= JMAFeed::Report.get.detect{_1.has_code?(report_code)}
  end

  def report_area_code
    @report_area_code ||= identifier_components[3]
  end

  def report_status
    @report_status ||= identifier_components[1]
  end

  def get_report_entry!
    return unless report
    report.report_entry_class.get(id)
  end
end
