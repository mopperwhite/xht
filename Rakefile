#!/usr/bin/env ruby
#encoding=utf-8
require './init'
require './db'

task :default do
  puts "Use `rake -D' to see all commands."
end

desc 'Run web server to display doujinshis.'
task :run do
  system 'rackup'
end

desc 'Create a user to login.'
task :seed do
  prompt = TTY::Prompt.new
  if prompt.yes?("Do you want to set a password?")
    username = prompt.ask("What is your username?")
    password = prompt.mask("What is your password?")
    KeyValue[:authorize] = true
    User.set_user(username, password)
  else
    KeyValue[:authorize] = false
  end
end