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
require 'r_form/input_text'

describe RForm::InputText do
#  let(:valid_attrib) do
#    {
#      :charset => 'utf8',
#      :autocomplete => true,
#      :name => 'any-name',
#      :id => 'any-id',
#      :class => 'any-class',
#      :size => 200,
#      :minlangth => 5,
#      :maxlangth => 200,
#      :required => false,
#      :pattern  => /.*/,
#      :readonly => false,
#      :disabled => false,
#    }
#  end

  let :request do
    {:post => {}, :get => {}}
  end
  
  let(:id) {:txt_1}
    
  before(:each) do
    @input_text = RForm::InputText.new id, request
    @testobj = @input_text
  end
end

