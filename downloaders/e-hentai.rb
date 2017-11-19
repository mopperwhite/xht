#!/usr/bin/env ruby
#encoding=utf-8
class EHentai
  include Downloader
  
  match do
    host 'e-hentai.org'
  end

  on_first_page do |url|
    doc = agent.get url
    get_meta parse_meta doc
    get_title doc
    cover_style = doc.at('#gd1 > div')[:style]
    /background:transparent url\(.+?\)/ === cover_style
    download_image($1, 'cover.jpg')
    meta.cover = 'cover.jpg'
    add_image_page doc.at('#gdt > .gdtm > div > a')[:href]
  end

  def parse_meta(doc)
    doc.css('#taglist tr').map do |tr|
      ktd, vtd = tr.css('td')
      values = vtd.css('div').map(&:text)
      [ktd.text, values]
    end.to_h
  end

  def get_title(doc)
    meta.title_lang[:english]= doc.at('h1#gn')&.text
    meta.title_lang[:japanese]= doc.at('h1#gj')&.text
  end

  def get_meta(dict)
    meta.language = dict['language:'].detect{ |l| l!='translated' }
    meta.author   = dict['artist:']
    meta.group   = dict['group:']
    meta.tags.concat  ["male:", "female:", "misc:"]
                        .select{|x| dict.has_key? x}
                        .map{|x| dict[x]}
                        .reduce(&:concat)
    meta.characters.concat dict["character:"] if dict.has_key? "character:"
  end

  on_image_page do |url|
    doc = agent.get url
    add_image doc.at("#img")[:src]
    next_url = doc.at("#next")[:href]
    add_image_page(next_url) if next_url != url
  end

  on_image do |url|
    index = task.next_image_index!
    ext = File.extname(url)
    filename = "#{index}.#{ext}"
    task.add_image(url, index, filename)
    download_image(url, filename)
  end
end