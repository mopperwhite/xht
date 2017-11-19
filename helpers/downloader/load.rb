Dir['./downloaders/*.rb'].each do |f|
  load f, true
end