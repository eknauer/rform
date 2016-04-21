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

module RForm
  module Core
    class << self
      def get_clone a
        begin
          res = a.clone
        rescue
          res = a
        end
        res
      end
    end
    
    class ::Array
      def deep_clone
        res = []
        self.each_index do |key|
          if self[key].is_a? Array
            res[key] = self[key].deep_clone
          else
            res[key] = RForm::Core.get_clone(self[key])
          end
        end
        res
      end # def deep_clone
    end # class ::Array
    
    class ::Hash
      def deep_clone
        res = {}
        self.each_key do |key|
          if self[key].is_a?(Hash) or self[key].is_a?(Array)
            res[key] = self[key].deep_clone
          else
            res[key] = RForm::Core.get_clone(self[key])
          end
        end
        res
      end
      
      def deep_merge hash
        unless hash.is_a? Hash
          raise ArgumentError, "Invalid parameter class: '#{hash.class}'. Hash expected."
        end
        res = self.deep_clone
        hash.each do |key, val|
          if res[key]
            if res[key].is_a?(Hash) and val.is_a?(Hash)
              res[key] = res[key].deep_merge(val)
            else
              if val.is_a?(Hash) or val.is_a?(Array)
                res[key] = val.deep_clone
              else
                res[key] = RForm::Core.get_clone(val)
              end
            end
          else
            if val.is_a?(Hash) or val.is_a?(Array)
              res[key] = val.deep_clone
            else
              res[key] = RForm::Core.get_clone(val)
            end
          end
        end
        res
      end
    end # class ::Hash
  end # module Core
end # module RForm
