#!/usr/bin/env ruby
#encoding=utf-8
require './lib/init'
require './lib/db'
require './lib/dsl_builder'
require './lib/plugins'

if $0 == __FILE__
  p ARGV.first
  url = ARGV.first
  if url.nil? || Downloader.exists?(url)
    puts "Task exists: #{url}, ignored."
  else
    Downloader.add_task(url)
  end
  Downloader.start
end