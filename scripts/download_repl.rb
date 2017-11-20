#!/usr/bin/env ruby
#encoding=utf-8
require './lib/init'
require './lib/db'
require './lib/dsl_builder'
require './lib/downloader'
require './lib/download_server'

if $0 == __FILE__
  prompt = TTY::Prompt.new
  DownloadServer.start
  loop do
    begin
      url = prompt.ask("url>")
      next if url.nil? || url.empty?
      Downloader.add_task(url)
    rescue TTY::Reader::InputInterrupt
      puts "Exiting."
      DownloadServer.stop
      break
    end
  end
end