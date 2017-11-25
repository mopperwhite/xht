#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/app/ws_room'

require 'json'

class WebViewer
  @@ws_event = WSEvent.new
  @@ws_room = WSRoom.new(@@ws_event)

  get '/io' do
    # puts "FUCK"
    # puts JSON.pretty_generate(request.env)
    # ??? 
    if request.websocket?
      request.websocket do |ws|
        ws.onopen do
          @@ws_event.on_open(ws)
        end
        ws.onmessage do |msg|
          # EM.next_tick do
            @@ws_event.on_message(ws, msg)
          # end
        end
        ws.onclose do
          @@ws_event.on_close(ws)
        end
      end
    else
      halt 401
    end
  end
end