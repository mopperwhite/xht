#!/usr/bin/env ruby
#encoding=utf-8
require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'yaml'
require 'json'
require 'uri'
require 'fiber'
require 'fileutils'
require 'logger'
require 'tempfile'

$logger = Logger.new($stderr)
$logger.formatter = proc do |severity, datetime, progname, msg|
  "- #{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity}: #{msg}\n"
end