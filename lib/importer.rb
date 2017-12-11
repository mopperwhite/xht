#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/structs'

$importers = {}

module Importer
  module_function
  def register(name, &block)
    $importers.store name.to_sym, block
  end

  def import(name, from_dir, root_dir)
    proc = $importers[name.to_sym]
    raise RuntimeError.new("Importer `#{name}' not registed.") if proc.nil?
    proc.call(from_dir, root_dir)
  end

  def sort_files(files)
    files.sort{|x, y|
      mx = File.mtime(x)
      my = File.mtime(y)
      x = File.basename x
      y = File.basename y
      next mx <=> my unless /^(.*)(\d+)\D*$/ === x
      fx = $1
      nx = $2.to_i
      next mx <=> my unless /^(.*)(\d+)\D*$/ === y
      fy = $1
      ny = $2.to_i
      fx == fy ? nx <=> ny : fx <=> fy
    }
  end

  def importers
    $importers.keys
  end
end

# Dir['./importers/*.rb'].each do |f|
#   load f, true
# end