#!/usr/bin/env ruby
#encoding=utf-8
require 'securerandom'
$access_dict      = {}
$access_code      = {}
$accessable_ws    = {}
module AccessCode
  module_function
  def first_or_create(username)
    if $access_code.has_key?(username)
      $access_dict[username]
    else
      uuid = SecureRandom.uuid
      $access_dict[username] = uuid
      $access_code[uuid] = username
      uuid
    end
  end
  def get(username)
    return $access_dict[username]
  end
  def register(ws, code)
    if $access_code[code]
      $accessable_ws[ws] = code
      true
    else
      false
    end
  end
  def unlink(ws)
    $accessable_ws.delete(ws)
  end
  def accessable?(ws)
    ! KeyValue['authorize'] || $accessable_ws[ws]
  end
end