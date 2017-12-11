#!/usr/bin/env ruby
#encoding=utf-8

require './lib/downloader'
require './lib/importer'

Dir[File.join('plugins', '*')].each do |package_dir|
  config = YAML.load_file File.join(package_dir, 'package.yaml')
  $logger.debug("Loading plugin: #{config['name']} (#{package_dir})")
  entry_path = File.join(package_dir, config['entry'])
  load entry_path, true
end