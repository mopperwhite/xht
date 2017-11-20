#!/usr/bin/env ruby
#encoding=utf-8
module Downloader
  def initialize_agent()
    @agent = Mechanize.new
    @agent.user_agent_alias = KeyValue['user_agent']

    if KeyValue['use_http_proxy']
      @agent.set_proxy KeyValue['http_proxy_host'], KeyValue['http_proxy_port']
    end
    load_cookies()
  end

  def load_cookies()
    Dir['./cookies/*.{yaml,json}'].each do |f|
      data = YAML.load_file f
      if data.is_a? Array
        data.each do |d|
          agent.cookie_jar << Mechanize::Cookie.new(d)
        end
      else # assume that data is a Hash
        agent.cookie_jar << Mechanize::Cookie.new(data)
      end
    end
  end
end