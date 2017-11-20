#!/usr/bin/env ruby
#encoding=utf-8
class NHentai
  include Downloader
  
  match do
    host 'nhentai.net'
    tag  :nhentai
  end

  on_first_page do |url|
    doc = agent.get url
    get_meta parse_meta doc
    get_title doc
    cover_url = doc.at('#cover > a > img')['data-src']
    download_image(cover_url, 'cover.jpg')
    meta.cover = 'cover.jpg'
    $logger.debug "> Cover: #{cover_url}"
    meta.source = url
    add_image_page 'https://nhentai.net'+doc.at('#thumbnail-container > .thumb-container > a')[:href]
  end

  def parse_meta(doc)
    doc.css('.tag-container').map do |tr|
      ktd = tr.at('./text()')
      vtd = tr.xpath('.//span[@class="tags"]/a[starts-with(@class, "tag")]/text()')
      values = vtd.map(&:text)
      [ktd.text.strip, values]
    end.to_h
  end

  def get_title(doc)
    meta.title_lang[:english]= doc.at('#info > h1')&.text
    meta.title_lang[:japanese]= doc.at('#info > h2')&.text
  end

  def get_meta(dict)
    meta.language = dict['Languages:']&.detect{ |l| l!='translated' }
    meta.author   = dict['Artists:']&.first
    meta.group   =  dict['Groups:']&.first
    meta.tags.concat dict["Tags:"] if dict.has_key? "Tags:"
    meta.characters.concat dict["Characters:"] if dict.has_key? "Characters:"
  end

  on_image_page do |url|
    $logger.debug "Parsing: #{url}"
    doc = agent.get url
    img_url = doc.at("section#image-container > a > img")[:src]
    $logger.debug "Get IMGURL #{img_url}"
    add_image img_url
    next_ele = doc.at("a.next")
    unless next_ele&.[](:href).nil?
      nu = 'https://nhentai.net' + next_ele[:href]
      $logger.debug "Next: #{nu}"
      add_image_page(nu) 
    end
    sleep rand 2..5
  end

  on_image do |url|
    index = task.next_image_index!
    ext = File.extname(url)
    filename = "#{index}#{ext}"
    $logger.debug "Downloading: #{url} > #{filename}"
    task.add_image(url, index, filename)
    download_image(url, filename)
  end
end