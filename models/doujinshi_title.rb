#!/usr/bin/env ruby
#encoding=utf-8
class DoujinshiTitle
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String, length: 0..500
  property :has_lang,   Boolean
  property :lang,       String

  belongs_to :doujinshi_meta
end