# encoding: UTF-8
#
#The MIT License
#
#Copyright 2016 Eduard Knauer <eduard.knauer@mail.ru>.
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

module RForm
  module Core
    class Error < StandardError; end
    
    class Object
      attr_reader :label
      
      def initialize request
        unless request.is_a? Hash
          raise Error, "Invalid class of the parameter: #{request.class}. Hash expected."
        end
        @request = request
        @label = false
      end
      
      def label= val
        raise RForm::Core::Error, "The parameter is not a string" unless val.kind_of? String
        raise RForm::Core::Error, "The label is empty" unless val.size > 0
        @label = val
      end
      
      def data
        raise RForm::Core::Error, 'must be overloaded'
      end
    end
  end
end
