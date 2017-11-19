#!/usr/bin/env ruby
#encoding=utf-8

class DSLContent
  attr_reader :_content
  def initialize
    @_content = {}
  end
  def method_missing(name, *args)
    if args.length == 1
      @_content.store name, args.first
    elsif args.length == 2
      @_content.store(name, {}) if @_content.has_key?(name)
      @_content[name].store(args.first, args.last)
    else
      raise RuntimeError.new "Bad number of arguments: `#{args.length}', 1..2 expected."
    end
  end
  def _eval(block)
    instance_eval &block
  end
end

class DSLBuilder
  def initialize(set_variable = false)
    @_set_variable = set_variable
  end
  def parse_to(obj, &block)
    content = DSLContent.new
    content._eval block
    content._content.each_pair do |k, v|
      if @_set_variable
        obj.instance_variable_set :"@#{k}", v
      else
        begin
          obj.send(:"#{k}=", v)
        rescue NoMethodError
          raise RuntimeError.new "Failed to set: `#{k}'`"
        end
      end
    end
  end
end
