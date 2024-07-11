# README

# DEVELOPMENT GUIDE

## REPL

Since `Gemfile` has the line below, you just run `require "jma_feed"` in `bundle exec irb` to start `JMAFeed`.

```
gem "jma_feed", path: './'
```

```
bundle install
```

```
bundle exec irb

# (irb):> require "jma_feed"
```

## Local Build

Since it has `Rakefile`, you just run the following command to make build and install it on your local.

```
bundle exec rake build
bundle exec rake install
```

Then you just run `require "jma_feed"` in `irb` to start `JMAFeed`.

```
irb

(irb):> require "jma_feed"
```

## Publish Gem

If you have the right to publish it to rubygems, run it.

```
bundle exec rake build
gem push ./pkg/jma_feed-${VERSION}.gem
```
