#!/usr/bin/env ruby
#encoding=utf-8
class User
  include DataMapper::Resource
  property :username, String, key: true
  property :pwd_hash, String

  include BCrypt
  def confirmed?(pwd)
    bp = Password.new pwd_hash
    bp == pwd
  end
  def set_passowrd(pwd)
    bp = Password.create(pwd)
    self.pwd_hash = bp
  end

  class << self
    def exists?(username)
      count(username: username) != 0
    end
    def users
      all.map(&:username)
    end
    def authorized?(username, password)
      user = first(username: username)
      user.nil? ? false : user.confirmed?(password)
    end
    def set_user(username, password)
      user = first_or_create(username: username)
      user.set_passowrd(password)
      user.save!
    end
  end
end