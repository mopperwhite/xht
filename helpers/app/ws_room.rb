#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/accessable'
class WSEvent
  attr_reader :connections
  def initialize
    @procs = {}
    @procs.default_proc = proc {|d, k| d[k] = Array.new}
    @connections = {}
  end

  def on_open(ws)
    $logger.debug "WS connected: #{ws}"
    @connections[ws] = true
  end

  def on_message(ws, msg)
    begin
      evt = JSON.parse(msg)
    rescue JSON::ParserError
      $logger.error 'json parse error'
      return
    end
    unless evt.has_key?('event') && evt.has_key?('payload')
      $logger.error "invalid structure: #{msg}"
      return
    end
    $logger.debug "WS event: #{evt['event']} (#{ws})"
    emit_local_message(ws, evt['event'], evt['payload'])
  end

  def emit_local_message(ws, event, payload = nil)
    @procs[event].each do |pr|
      pr.call(payload, ws)
    end
  end

  def on_close(ws)
    $logger.debug "WS disconnected: #{ws}"
    emit_local_message(ws, 'disconnected')
    @connections.delete(ws)
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
    
    on 'pair' do |code, ws|
      $logger.debug "joined room: #{code} -- #{ws}"
      # puts @ws_room_dict.keys
      if @ws_room_dict.has_key?(ws)
        leave_room(ws)
      end
      join_room(ws, code)
    end

    on 'leave' do |code, ws|
      leave_room(ws)
    end

    on 'key' do |key, ws|
      broadcast(ws, 'key', key)
    end

    @event.on 'ping' do |_, ws|
      $logger.debug "ping #{ws}"
      emit(ws, 'pong', nil)
    end

    @event.on 'disconnected' do |_, ws|
      $logger.debug "disconnected from #{ws}"
      leave_room(ws)
      AccessCode.unlink(ws)
    end

    @event.on 'access' do |code, ws|
      emit(ws, 'access', AccessCode.register(ws, code))
    end
  end

  def on(evt, &block)
    @event.on(evt)do |payload, ws|
      block.call(payload, ws) if AccessCode.accessable?(ws)
    end
  end

  def broadcast(ws, evt, msg, self_included = false)
    code = @ws_room_dict[ws]
    $logger.debug "broadcast `#{evt}' to #{@ws_rooms[code]&.length} users"
    @ws_rooms[code]&.each do |w|
      next if !self_included && w == ws
      emit(w, evt, msg)
    end
  end

  def global_broadcast(evt, payload=nil)
    $logger.debug "Global broadcast: #{evt}"
    @event.connections.each_key do |ws|
      $logger.debug "#{evt} => #{ws}"
      emit(ws, evt, payload) if AccessCode.accessable?(ws)
    end
  end

  def emit(ws, evt, payload)
    @event.emit(ws, evt, payload)
  end

  def join_room(ws, code)
    @ws_room_dict[ws] = code
    @ws_rooms[code].push(ws)
    emit(ws, 'message', nil)
    broadcast(ws, 'message', "Room #{code}: Connected with #{@ws_rooms[code].length-1} Devices.", true)
  end

  def leave_room(ws)
    room = @ws_room_dict[ws]
    return if room.nil?
    emit(ws, 'message', "Disconnected from Room #{room}.")
    broadcast(ws, 'message', "Disconnected from 1 Device.")
    @ws_rooms[room].delete(ws)
    @ws_room_dict.delete(ws)
  end

end
