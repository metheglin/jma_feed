class JMAFeed::Report < Struct.new(
  :name, :title, :kind, :category, :code_represented, :codes, keyword_init: true
)
  CSV_ROW_SEP = "\r\n"
  NUM_HEADER_ROWS = 3
  HEADERS = %i(
    number
    category
    kind
    name
    title
    code
    compression_format
    size_average
    size_max
    memo
    code_old
  )

  class << self
    def load_csv(version: "20240216")
      path = File.join(File.dirname(__FILE__), "../../data/jmaxml_#{version}_format_v1_3_hyo1.csv")
      File.open(path) do |f|
        csv = CSV.new(f, headers: HEADERS, row_sep: CSV_ROW_SEP)
        yield(csv)
      end
    end

    def load(**args)
      load_csv(**args) do |csv|
        csv.drop(NUM_HEADER_ROWS).map do |row|
          build_by_csv_row(row)
        end
      end
    end

    def build_by_csv_row(row)
      codes = build_codes(row[:code])
      code_represented = build_code_represented(row[:code])
      new(
        name: row[:name], 
        title: row[:title], 
        kind: row[:kind].split('／'),
        category: row[:category],
        code_represented: code_represented,
        code: codes,
      )
    end

    def parse_raw_code(raw_code)
      raw_code.match(/(.+)\（([^\)]+)\）/)
    end

    def build_code_represented(raw_code)
      if m = parse_raw_code(raw_code)
        _, main, cond = m.to_a
        main
      else
        raw_code
      end
    end

    # build_code('VGSK50')
    #   => 'VGSK50'
    # build_code('VPTWii（ii=40-45）')
    #   => ["VPTW40", "VPTW41", "VPTW42", "VPTW43", "VPTW44", "VPTW45"]
    # build_code('VXKO（ii=50-89）')
    #   => ["VXKO50", "VXKO51", "VXKO52", "VXKO53", "VXKO54", "VXKO55", ...]
    def build_codes(raw_code)
      if m = parse_raw_code(raw_code)
        _, main, cond = m.to_a
        cursor, range = cond.split('=')
        range_first, range_last = range.split('-').map(&:to_i)
        (range_first..range_last).map do |i|
          main.match?(cursor) ?
            main.sub(cursor, i.to_s) :
            main + i.to_s
        end
      else
        [raw_code]
      end
    end
  end

  def has_code?(c)
    codes.include?(c)
  end

  def has_kind?(k)
    Array(kind).include?(k)
  end
end
