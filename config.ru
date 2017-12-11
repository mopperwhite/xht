#!/usr/bin/env ruby
#encoding=utf-8
require './lib/init'
require './lib/dsl_builder'
require './lib/db'
require './lib/downloader'
require './lib/download_server'
require './lib/importer'
require './lib/app'
require './lib/plugins'


DownloadServer.start
at_exit do
  DownloadServer.stop
end
run WebViewer