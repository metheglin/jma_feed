lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jma_feed/version"

Gem::Specification.new do |s|
  s.name         = "jma_feed"
  s.version      = JMAFeed::VERSION
  s.summary      = "JMA Feed"
  s.description  = "JMA Feed"
  s.authors      = ["metheglin"]
  s.email        = "pigmybank@gmail.com"
  s.files        = Dir["{lib}/**/*.rb", "{lib}/**/*.rake", "bin/*", "LICENSE", "*.md", "data/**/*"]
  s.homepage     = "https://rubygems.org/gems/jma_feed"
  # s.executables  = %w(jma_feed)
  s.require_path = 'lib'
  s.license      = "MIT"

  s.required_ruby_version = ">= 2.7"
  s.add_dependency "rake", "~> 13.0"
  s.add_dependency "nokogiri"
  s.add_dependency "jma_code", "~> 0.0.2"
  s.add_dependency "giri", "~> 0.0.2"
end