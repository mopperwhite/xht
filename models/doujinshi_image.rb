#!/usr/bin/env ruby
#encoding=utf-8
class DoujinshiImage
  include DataMapper::Resource
  property :id,         Serial
  property :index,      Integer
  property :url,        String
  property :filename,   String

  belongs_to  :doujinshi
end