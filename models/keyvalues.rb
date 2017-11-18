#!/usr/bin/env ruby
#encoding=utf-8

$default_keyvalues_file = 'default_keyvalues.yaml'

class KeyValue
  KeyError = Class.new RuntimeError

  include DataMapper::Resource
  property :k,  String, key: true
  property :v,  Text

  @@_default = YAML.load_file $default_keyvalues_file
  class << self
    def [](key)
      key = key.to_s
      row = first(k: key)
      val = row.nil? ? @@_default[key] : JSON.parse(row.v)
      throw KeyError.new("Key `#{key}' does not exist.`") if val.nil?
      val
    end
    def []=(key, value)
      all(k: key).update(v: value.to_yaml)
      value
    end
    def keys()
      all.map(&:k)
    end
  end
end