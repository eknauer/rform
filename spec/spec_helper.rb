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

require 'simplecov'

SimpleCov.profiles.define 'specs' do
  add_group 'Libraries', '/lib/'
  add_filter '../spec/'
end

SimpleCov.start 'specs'

require "minitest/autorun"
require 'r_form/core/object'

module RForm
  class InputTextFixture
    attr_reader :namespace, :request
    attr_accessor :data, :error
    def initialize id, request, namespace
      @namespace = namespace
      @request = request
    end
    
    def error?
      @error
    end
  end
  
  class TextAreaFixture < InputTextFixture
    def initialize id, request, namespace
      super id, request, namespace
    end
  end
  
  class InputHidden
    attr_reader :namespace, :request
    def initialize id, request, namespace
      @namespace = namespace
      @request = request
    end
  end
  
  class ObjectFixture < Core::Object
    attr_reader :request

    def initialize request
      super
    end
  end
end
