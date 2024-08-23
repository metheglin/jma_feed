class JMAFeed::Regular
  include JMAFeed::Atom

  def feed_type
    :regular
  end
end
