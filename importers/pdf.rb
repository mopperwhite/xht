#!/usr/bin/env ruby
#encoding=utf-8

Importer.register :pdf do |from_dir, root|
  dir_name = File.basename(from_dir, '.pdf')
  dist_dir = File.join(root, dir_name)
  meta = MetaInfo.new

  doujinshi = Doujinshi.add(from_dir)
  meta.title = dir_name
  meta.cover = '0.png'

  doujinshi.create_meta(meta)
  
  FileUtils.mkpath dist_dir

  Magick::Image.read(from_dir).each_with_index do |img, index|
    f = "#{index}.png"
    doujinshi.download_task.add_image(nil, index, f)
    img.write(File.join(dist_dir, f))
  end

  File.write (File.join dist_dir, 'meta.yaml'), meta.to_h.merge(
    images: doujinshi.images
  ).to_yaml
  doujinshi.set_dir(dir_name)
  doujinshi.download_task.finish!
end