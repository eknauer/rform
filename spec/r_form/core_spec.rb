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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RForm::Core do
  describe "::get_clone" do
    it "must get clone of string" do
      a = "str1"
      b = RForm::Core.get_clone(a)
      b.must_equal a
      a = "str2"
      b.wont_equal a
    end
    
    it "must get clone of a Fixnum" do
      a = 6
      b = RForm::Core.get_clone(a)
      b.must_equal a
      a += 1
      b.wont_equal a
    end
  end
end

describe Array do
  it "deep_clone" do
    a = [
      'a',
      'b',
      [
        'aa',
        'bb',
        [
          'aaa',
          'bbb',
        ],
        'cc',
        'dd',
      ]
    ]
    b = a.deep_clone
    b.must_equal a
    b[2][2][0] = 'TTT'
    b.wont_equal a
  end
end

describe Hash do
  it 'deep_clone' do
    a = {
      :a => 'a',
      :b => 'b',
      :c => {
        :aa => 'aa',
        :bb => {
          :aaa => ['aaa', 'bbb', 'ccc'],
        }
      }
    }
    b = a.deep_clone
    a.must_equal b
    b[:c][:bb][:aaa][1] = 'FFF'
    a.wont_equal b
  end
  
  describe '#deep_merge' do
    it 'must raise exception if argument is not a hash' do
      a = {}
      err = proc{a.deep_merge 'f'}.must_raise ArgumentError
      err.message.must_match /[Ii]nvalid parameter class/
    end
    
    it 'must merge to hashes' do
      a = {
        :a => 'a',
        :b => {
          :aa => 'aa',
          :cc => 'C_c'
        },
        :c => 'FG',
        :d => [5,6,7],
      }
      
      b = {
        :b => {
          :bb => 'bb',
          :cc => 'cc',
        },
        :c => [1,2,3],
        :d => 'd',
        :e => 'e',
      }
      
      expected = {
        :a => 'a',
        :b => {
          :aa => 'aa',
          :bb => 'bb',
          :cc => 'cc',
        },
        :c => [1,2,3],
        :d => 'd',
        :e => 'e',
      }
      res = a.deep_merge(b)
      res.must_equal expected
    end
  end
end

