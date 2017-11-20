#!/usr/bin/env ruby
#encoding=utf-8
Importer.register :dir do |from_dir, root|
  meta_file = File.join(from_dir, 'meta.yaml')
  dir_name = File.basename(from_dir)
  dist_dir = File.join(root, dir_name)
  meta = MetaInfo.new
  files = Importer.sort_files(
    Dir[File.join from_dir, '*.{jpg,jpeg,png,gif}']
  ).map{|f| File.basename f}

  doujinshi = if File.exists? meta_file
    meta_info = YAML.load_file meta_file
    meta.title_lang[:english] = meta_info[:title_en]
    meta.title_lang[:japanese] = meta_info[:title_jp]
    Doujinshi.add(meta_info[:url], nil)
  else
    meta.title = dir_name
    Doujinshi.add(from_dir)
  end
  meta.cover = files.first

  doujinshi.create_meta(meta)
  
  FileUtils.mkpath dist_dir

  files.each_with_index do |f, index|
    doujinshi.download_task.add_image(nil, index, f)
    ff = File.join(from_dir, f)
    tf = File.join(dist_dir, f)
    FileUtils.copy ff, tf
  end

  File.write (File.join dist_dir, 'meta.yaml'), meta.to_h.merge(
    images: doujinshi.images
  ).to_yaml

  doujinshi.set_dir(dir_name)
  doujinshi.download_task.finish!
end