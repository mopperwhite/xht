#!/usr/bin/env ruby
#encoding=utf-8
require 'tempfile'
$cached_files = {}
module FileCache
  module_function
  def add(key, file)
    $cached_files.store(key, file)
  end
  def exists?(key)
    $cached_files.has_key?(key)
  end
  def get(key)
    $cached_files[key]
  end
end
  