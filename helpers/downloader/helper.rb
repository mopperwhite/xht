#!/usr/bin/env ruby
#encoding=utf-8
module Downloader
  module_function
  def cut_dir(str, len)
    str = str.clone
    [
      /\{.+?\}/,
      /\(.+?\)/,
      /\[.+?\]/
    ].each do |pat|
      break if str.bytesize <= len
      str.gsub!(pat, '')
    end

    while str.bytesize > len
      str.slice!(0, str.length / 2)
    end
    str
  end

  def dir_name
    @dir_name ||= dir_name!
  end

  def dir_name!()
    p @meta
    title = if @meta.title.nil?
        default_lang = KeyValue['dir_lang'].to_sym
        if @meta.title_lang.has_key? default_lang
          @meta.title_lang[default_lang]
        elsif @meta.title_lang.has_key? :en
          @meta.title_lang[:english]
        else
          @meta.title_lang.values.first
        end
      else
        @meta.title
      end
    raise RuntimeError.new 'title is not set.' if title.nil?
    max_length = KeyValue['dir_max_len']
    title = cut_dir(title, max_length) if 
      max_length.is_a?(Numeric) && 
      max_length > 0 && 
      title.length > max_length
    title
  end
end

