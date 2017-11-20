#!/usr/bin/env ruby
#encoding=utf-8
require 'yaml'
require 'json'
require 'uri'
require 'fiber'
require 'fileutils'
require 'logger'
require 'tempfile'
require 'bundler/setup'
Bundler.require(:default)

$logger = Logger.new($stderr)