class JMAFeed::RiskLevel
  # Ex: id=:level0
  # Ex: code='00'

  # 大雨危険度通知_解説資料.pdf > 別表3 「危険度分布の危険度」コード表
  LIST = {
    level0: ['00'], # 今後の情報等に留意
    level1: ['11', '13'], # 警戒レベル1(心構えを高める), 早期注意情報
    level2: ['21', '22', '23', '24'], # 警戒レベル2(避難行動の確認)相当, 注意報
    level3: ['31', '32', '33', '34'], # 警戒レベル3(高齢者等避難)相当, 警報
    level4: ['41', '42', '43', '44'], # 警戒レベル4(避難)相当, 危険
    level5: ['51', '52', '53', '54'], # 警戒レベル5(災害切迫)相当, 災害発生のおそれ
  }

  def self.all
    @all ||= LIST.map{|k,v| new(k, v)}
  end

  def self.find(id)
    all.find{|l| l.id == id.to_sym}
  end

  def self.greater_than(level)
    level = (level.is_a?(Symbol) or level.is_a?(String)) ? 
      find(level) : 
      level
    all.select{|l| l.intensity >= level.intensity}
  end

  attr_reader :id, :codes
  def initialize(id, codes)
    @id = id.to_sym
    @codes = codes
  end

  def intensity
    @intensity ||= id.to_s.sub('level', '').to_i
  end

  def risk_include?(code)
    risk_codes = self.class.greater_than(self).map(&:codes).flatten
    risk_codes.include?(code)
  end
end