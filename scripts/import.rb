#!/usr/bin/env ruby
#encoding=utf-8
require './lib/init'
require './lib/db'
require './lib/dsl_builder'
require './lib/plugins'

if __FILE__ == $0
  importer, path = ARGV
  Importer.import(importer, path, KeyValue['save_dir'])
end