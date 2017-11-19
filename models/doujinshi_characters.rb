#!/usr/bin/env ruby
#encoding=utf-8
class DoujinshiCharacter
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  belongs_to :doujinshi_meta
end