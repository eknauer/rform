# The MIT License
#
# Copyright 2016 Eduard Knauer <eduard.knauer@mail.ru>.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'r_form/core'

module RForm
  class Error < Core::Error; end
  
  class Form < Core::Object
    attr_reader :elements, :start, :finish
    
    @@valid_attr = [
      :charset,
      :action,
      :autocomplete,
      :enctype,
      :method,
      :name,
      :id,
      :class,
    ]
    
    def initialize request, attributes
      super request
      raise Error, ':post key missed.' unless request[:post]
      unless request[:post].is_a? Hash
        raise Error, ":post is not a hash: #{request[:post].class}"
      end
      raise Error, ':get key missed.' unless request[:get]
      unless request[:get].is_a? Hash
        raise Error, ":post is not a hash: #{request[:get].class}"
      end
      unless attributes.is_a? Hash
        raise ArgumentError.new(
          "Invalid class of the second parameter '#{attributes.class}' Hash expected."
        )
      end
      attributes.each_key do |key|
        raise Error.new("Invalid attribute: #{key}") unless @@valid_attr.include? key
      end
      raise Error.new ':id attribute missed' unless attributes[:id]
      raise Error.new ':action attribute missed' unless attributes[:action]
      @request = request
      @attributes = attributes
      @attributes[:method] = 'post' unless @attributes[:method]
      unless @attributes[:method] =~ /\A(post|get)\Z/
        raise(
          Error,
          "Invalid value for the method attribute '#{@attributes[:method]}'. Expected 'post' or 'get'."
        )
      end
      @elements = []
      @econtainer = {}
      @start = '<form '
      @attributes.each do |key, val|
        case key
        when :autocomplete
          str = ' %{n}="%{v}"' % {:n => key.to_s, :v => val ? 'on' : 'off'}
        when :charset
          str = ' accept-charset="%{v}"' % {:v => val}
        else
          str = ' %{n}="%{v}"' % {:n => key.to_s, :v => val}
        end
        @start << str
      end
      @start << '>'
      @finish = '</form>'
      @controls = {}
    end
    
    def namespace= nspace
      unless nspace =~ /\A[a-z0-9_-]{4,40}\Z/
        raise RForm::Error, "Namespace conteins not allowed chars: '#{nspace}'"
      end
      @namespace = nspace
    end
    
    def global_nspace= nspace
      req = @request[:get].deep_merge(@request[:post])
      if req[nspace]
        req[nspace].each_key do |key|
          id = "hidden_#{nspace}_#{key}".to_sym
          @elements << id
          @econtainer[id] = RForm::InputHidden.new id, req, nspace
        end
      end
    end
    
    def add tag, id
      raise RForm::Error, 'ID is not a symbol' unless id.is_a? Symbol
      raise RForm::Error, "ID #{id.inspect} is in using" if @econtainer[id]
      method = @attributes[:method].to_sym
      @elements << id
      @econtainer[id] = RForm.const_get(tag).new id, @request[method], @namespace
    end
    
    def get id
      raise RForm::Error, 'Parameter is not a symbol' unless id.is_a? Symbol
      @econtainer[id]
    end
    
    def sended?
      res = false
      if @controls.size > 0
        res = true
        @controls.each do |key, val|
          unless @econtainer[key] and @econtainer[key].data == val
            res = false
            break
          end
          if @econtainer[key].error?
            res = false
            break
          end
        end
      end
      res
    end
    
    def data
      res = {}
      @elements.each do |id|
        res[id] = @econtainer[id].data if @econtainer[id].data
      end
      res
    end
    
    def errors?
      res = false
      @econtainer.each do |key, val|
        if val.error?
          res = true
          break
        end
      end
      res
    end
    
    def errors
      res = {}
      @econtainer.each do |key, val|
        if val.error?
          res[key] = val.error
        end
      end
      res
    end
    
    def controls= val
      @controls = val
    end
  end
end
