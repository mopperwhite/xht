#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/app/ws_room'

class WebViewer
  @@ws_room = WSRoom.new

  get '/io' do
    if request.websocket?
      request.websocket do |ws|
        ws.onopen do
          @@ws_room.on_open(ws)
        end
        ws.onmessage do |msg|
          EM.next_tick do
            @@ws_room.on_message(ws, msg)
          end
        end
        ws.onclose do
          @@ws_room.on_close(ws)
        end
      end
    else
      halt 401
    end
  end
end