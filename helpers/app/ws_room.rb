#!/usr/bin/env ruby
#encoding=utf-8
class WSEvent
  def initialize
    @procs = {}
    @procs.default_proc = proc {|d, k| d[k] = Array.new}
  end

  def on_open(ws)
    $logger.debug "WS connected: #{ws}"
  end

  def on_message(ws, msg)
    begin
      evt = JSON.parse(msg)
    rescue JSON::ParserError
      $logger.error 'json parse error'
      return
    end
    unless evt.has_key?('event') && evt.has_key?('payload')
      $logger.error 'invalid structure'
      return
    end
    $logger.debug "WS event: #{evt['event']} (#{ws})"
    @procs[evt['event']].each do |pr|
      pr.call(evt['payload'], ws)
    end
  end

  def on_close(ws)
    $logger.debug "WS disconnected: #{ws}"
  end

  def on(event, &block)
    @procs[event.to_s].push(block)
  end

  def emit(ws, event, payload)
    ws.send({
      'event': event,
      'payload': payload
    }.to_json)
  end
end

class WSRoom
  attr_reader :event
  def initialize(event)
    @event        = event
    @ws_rooms      = {}
    @ws_rooms.default_proc = proc {|d, k| d[k] = Array.new}
    @ws_room_dict  = {}
    
    @event.on 'pair' do |code, ws|
      $logger.debug "joined room: #{code} -- #{ws}"
      puts @ws_room_dict.keys
      if @ws_room_dict.has_key?(ws)
        leave_room(ws)
      end
      join_room(ws, code)
    end

    @event.on 'leave' do |code, ws|
      leave_room(ws)
    end

    @event.on 'key' do |key, ws|
      broadcast(ws, 'key', key)
    end

    @event.on 'ping' do |_, ws|
      $logger.debug "ping #{ws}"
      emit(ws, 'pong', nil)
    end
  end

  def broadcast(ws, evt, msg)
    code = @ws_room_dict[ws]
    $logger.debug "broadcast `#{evt}' to #{@ws_rooms[code]&.length} users"
    @ws_rooms[code]&.each do |w|
      next if w == ws
      emit(w, evt, msg)
    end
  end

  def emit(ws, evt, payload)
    @event.emit(ws, evt, payload)
  end

  def join_room(ws, code)
    @ws_room_dict[ws] = code
    @ws_rooms[code].push(ws)
    emit(ws, 'join_room', nil)
  end

  def leave_room(ws)
    room = @ws_room_dict[ws]
    @ws_rooms[room].each do |ws|
      emit(ws, 'leave_room', nil)
    end
    @ws_rooms[room].delete(ws)
    @ws_room_dict.delete(ws)
  end

end
