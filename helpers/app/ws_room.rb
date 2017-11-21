#!/usr/bin/env ruby
#encoding=utf-8
class WSRoom
  def initialize
    @@ws_rooms      = {}
    @@ws_room_dict  = {}
  end

  def on_open(ws)
    $logger.debug "WS connected: #{ws}"
  end

  def on_message(ws, msg)
    $logger.debug "WS message: #{msg} (#{ws})"
  end

  def on_close(ws)
    $logger.debug "WS disconnected: #{ws}"
  end
end