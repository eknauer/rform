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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'r_form/core/object'

describe RForm::Core::Object do
  
  let(:request){ {:get => {}, :post => {}} }
  
  before do
    @object = RForm::Core::Object.new request
  end
  
  it "must respond to label" do
    @object.must_respond_to :label
  end

  it "must respond to label=" do
    @object.must_respond_to :label=
  end
  
  it 'must respond to data' do
    @object.must_respond_to :data
  end
  
  describe 'initialize' do
    it "must raise an exception if parameter is not a hash" do
      err = proc {RForm::Core::Object.new('any value')}.
        must_raise(RForm::Core::Error)
      err.message.must_match /Invalid class/
    end
    
    it 'must save the request' do
      t_request = {
        :get => {
          :gkey1 => 'g_val1',
          :gkey2 => 'g_val2',
        },
        :post => {
          :pkey1 => 'p_val1',
          :pkey2 => 'p_val2',
        },
      }
      obj = RForm::ObjectFixture.new t_request
      obj.request.must_equal t_request
    end
  end

  describe "label" do
    it "must return false" do
      @object.label.must_be_kind_of FalseClass
    end

    it "must save setted value" do
      val = "Any value"
      @object.label = val
      @object.label.must_equal val
    end  
  end
  
  describe "label=" do
    it "must raise en exceptions if param is not a string" do
      err = proc{@object.label = 78}.must_raise RForm::Core::Error
      err.message.must_match /is not a string/
    end

    it "must raise en exceptions if label is an empty string" do
      err = proc{@object.label = ''}.must_raise RForm::Core::Error
      err.message.must_match /is empty/
    end
  end
  
  describe 'data' do
    it 'must raise RForm::Core::Error' do
      err = proc{@object.data}.must_raise RForm::Core::Error
      err.message.must_match /must be overloaded/
    end
  end
end

