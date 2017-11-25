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
      item = first_or_create(k: key.to_s)
      item.v = value.to_yaml
      item.save
      value
    end
    def keys()
      all.map(&:k)
    end

    def to_h
      all(k: key, v: value).map do |item|
        [item.k, item.v]
      end.to_h.merge(@@_default)
    end

    def merge(obj)
      obj.each_pair do |k, v|
        next if count(k: k) == 0 && ! @@_default.has_key?(k)
        self[k]= v
      end
    end
  end
end