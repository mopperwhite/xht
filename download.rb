#!/usr/bin/env ruby
#encoding=utf-8
require './init'
require './db'
require './dsl_builder'
require './downloader'

if $0 == __FILE__
  p ARGV.first
  Downloader.download(ARGV.first)
end