class JMAFeed::Extra
  include JMAFeed::Atom
  
  def feed_type
    :extra
  end
end
