#!/usr/bin/env ruby
#encoding=utf-8

$database_path = 'sqlite:db.sqlite3'
DataMapper.setup(:default, $database_path)
Dir['./models/*.rb'].each do |model|
  require model
end
DataMapper.finalize.auto_upgrade!