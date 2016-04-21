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
require 'r_form/core/form_element'

describe RForm::Core::FormElement do
  
  let :empty_request do
    {:post =>{}, :get =>{}}
  end
  
  let(:nspace) {'my_namespace'}
  
  let :request do
    {
      :post => {
        nspace => {
          'p_ns_key1' => 'p_ns_val1',
          'p_ns_key2' => 'p_ns_val2',
          'p_ns_key3' => 'p_ns_val3',
        },
        'p_key1' => 'p_val1',
        'p_key2' => 'p_val2',
      },
      :get => {
        nspace => {
          'g_ns_key1' => 'g_ns_val1',
          'g_ns_key2' => 'g_ns_val2',
        },
        'g_key1' => 'g_val1',
        'g_key2' => 'g_val2',
      }
    }
  end
  
  let(:element_id) {
    :id
  }
  
  before do
    @form_element = RForm::Core::FormElement.new element_id, request, nspace
  end

  describe 'initialize' do
    it "must accept as first parameter only a symbol" do
      err = -> {RForm::Core::FormElement.new "any_id",  empty_request}.
        must_raise RForm::Core::Error
      err.message.must_match /[Ii]nvalid class/
    end
    
    it 'must create an object if all parameter are setted correctly.' do
      RForm::Core::FormElement.new(:any_id, empty_request).
        must_be_kind_of RForm::Core::FormElement
    end
    
    it 'must create an object if namespace is setted.' do
      RForm::Core::FormElement.new(:any_id, empty_request, 'any_namespace').
        must_be_kind_of RForm::Core::FormElement
    end
  end
  
  it 'must respond to attributes=' do
    @form_element.must_respond_to :attributes=
  end
  
  it 'must respond to data' do
    @form_element.must_respond_to :data
  end
  
  it 'must respond to error?' do
    @form_element.must_respond_to :error?
  end
  
  it 'must respond to checker' do
    @form_element.must_respond_to :checker
  end
end

