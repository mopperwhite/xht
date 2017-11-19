#!/usr/bin/env ruby
#encoding=utf-8
require './dsl_builder'

module Matchable
  def match?(url)
    ( @match.host && @match.host == URI(url).host ) ||
    ( @match.pattern && @match.pattern === url)
  end
  def match(&block)
    @match = UrlPattern.new
    DSLBuilder.new.parse_to @match, &block
  end
  def on_download(&block)
    @@download = block
  end
end