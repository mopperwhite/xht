#!/usr/bin/env ruby
#encoding=utf-8

class KeyValue
  include DataMapper::Resource
  property :k,  String, key: true
  property :v,  Text

  @@_cache = {}
  @@_has_key = {}
  class << self
    def [](key)
      if @@_has_key[key]
        @@_cache[key]
      elsif @@_has_key[key].nil?
        row = first(k: key.to_s)
        if row.nil?
          @@_has_key[key] = false
          nil
        else
          @@_has_key[key] = true
          YAML.load(row.v)
        end
      else
        nil
      end
    end
    def []=(key, value)
      @@_has_key.store  key, true
      @@_cache.store    key, (value.frozen? ? value : value.clone)
      if count(k: key) == 0
        create(k: key, v: value.to_yaml)
      else
        all(k: key).update(v: value.to_yaml)
      end
      value
    end
    def keys()
      all.map(&:key)
    end
  end
end