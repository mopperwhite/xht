#!/usr/bin/env ruby
#encoding=utf-8
class DoujinshiTag
  include DataMapper::Resource
  property :id, Serial
  property :tag,String
  belongs_to :doujinshi_meta
end