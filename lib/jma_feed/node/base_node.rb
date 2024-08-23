class JMAFeed::BaseNode < Giri::BaseNode
  self.with_name_default_for_node = :camelize
  self.with_name_default_for_attribute = :lower_camelcase
end
