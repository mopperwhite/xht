#!/usr/bin/env ruby
#encoding=utf-8

$database_file = 'db.sqlite3'
DataMapper.setup(:default, "sqlite:#{$database_file}")
Dir['./models/*.rb'].each do |model|
  require model
end
DataMapper.finalize.auto_upgrade!