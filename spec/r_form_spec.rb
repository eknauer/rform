# encoding: utf-8
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

require_relative 'spec_helper'
require 'r_form'

describe RForm::Form do
  let(:valid_attrib) do
    {
      :charset => 'utf8',
      :action => 'post',
      :autocomplete => true,
      :enctype => 'url-encoded',
      :method => 'post',
      :name => 'any-name',
      :id => 'any-id',
      :class => 'any-class',
    }
  end
  
  let(:minimal_attrib) do
    {
      :action => 'post',
      :id => 'any-id',
    }
  end

  let :request do
    {:post => {}, :get => {}}
  end

  before do
    @r_form = RForm::Form.new(request, valid_attrib)
  end

  it "must respond to add" do
    @r_form.must_respond_to :add
  end

  it "must respond to get" do
    @r_form.must_respond_to :get
  end

  it "must respond to elements" do
    @r_form.must_respond_to :elements
  end

  it "must respond to sended?" do
    @r_form.must_respond_to :sended?
  end

  it "must respond to data" do
    @r_form.must_respond_to :data
  end

  it 'must respond to errors?' do
    @r_form.must_respond_to :errors?
  end

  it 'must respond to namespace=' do
    @r_form.must_respond_to :namespace=
  end

  it 'must respond to global_nspace=' do
    @r_form.must_respond_to :global_nspace=
  end

  it 'must respond to errors' do
    @r_form.must_respond_to :errors
  end

  it 'must respond to controls=' do
    @r_form.must_respond_to :controls=
  end
    
  describe "initialize" do
    it "must raise an exception if :post key missed" do
      err = proc {RForm::Form.new({:get => {}}, valid_attrib)}.
        must_raise(RForm::Error)
      err.message.must_match /:post key missed/
    end
    
    it "must raise an exception if :post is not a hash" do
      err = proc {RForm::Form.new({:post => 'any_val'}, valid_attrib)}.
        must_raise(RForm::Error)
      err.message.must_match /not a hash/
    end
    
    it "must raise an exception if :get key missed" do
      err = proc {RForm::Form.new({:post => {}}, valid_attrib)}.
        must_raise(RForm::Error)
      err.message.must_match /:get key missed/
    end
    
    it "must raise an exception if :get is not a hash" do
      err = proc {RForm::Form.new({:post => {}, :get => 'any_val'}, valid_attrib)}.
        must_raise(RForm::Error)
      err.message.must_match /not a hash/
    end
    
    it "must raise an exception if second parameter has invalid class" do
      err = proc {RForm::Form.new({:post => {}, :get => {}}, 'any_param')}.
        must_raise(ArgumentError)
      err.message.must_match /Invalid[a-zA-Z0-9 ]+parameter/
    end
    
    it "must raise an exception if invalid attribute is setted" do
      err = proc {RForm::Form.new({:post => {}, :get => {}}, :attr1 => 1)}.
        must_raise(RForm::Error)
      err.message.must_match /Invalid attribute/
    end
    
    it "must raise an exception if id attribute missed" do
      attrib = valid_attrib
      attrib.delete(:id)
      err = proc {RForm::Form.new(request, attrib)}.must_raise RForm::Error
      err.message.must_match /:id attribute missed/
    end
    
    it "must raise an exception if method attribute missed" do
      attrib = valid_attrib
      attrib.delete(:action)
      err = proc {RForm::Form.new(request, attrib)}.must_raise RForm::Error
      err.message.must_match /:action attribute missed/
    end
    
    it 'must raise an exception if method is not allowed' do
      attr = valid_attrib
      attr[:method] = 'Post'
      err = proc {RForm::Form.new({:post => {}, :get => {}}, attr)}.
        must_raise(RForm::Error)
      err.message.must_match /[Ii]nvalid value for the method attribute/
    end
    
    it "must create an object of RForm::Form" do
      RForm::Form.new(request, valid_attrib).must_be_kind_of RForm::Form
    end
  end
  
  describe 'start' do
    it 'must return valid start tag fo formular' do
      @r_form.start.must_match /\A<form(\s+[^<>]+)?>\Z/
      @r_form.start.must_match /\s+accept-charset="#{valid_attrib[:charset]}"/
      @r_form.start.must_match(
        /\s+autocomplete="#{valid_attrib[:autocomplete] ? 'on' : 'off'}"/
      )
      @r_form.start.must_match /\s+enctype="#{valid_attrib[:enctype]}"/
      @r_form.start.must_match /\s+method="#{valid_attrib[:method]}"/
      @r_form.start.must_match /\s+name="#{valid_attrib[:name]}"/
      @r_form.start.must_match /\s+id="#{valid_attrib[:id]}"/
      @r_form.start.must_match /\s+class="#{valid_attrib[:class]}"/
    end
    
    it 'must contain default form method if no setted' do
      form = RForm::Form.new(request, minimal_attrib)
      form.start.must_match /\s+method="post"/
    end

    it "the form start tag must have only three attributes" do
      RForm::Form.new(request, minimal_attrib).must_be_kind_of RForm::Form
      form = RForm::Form.new(request, minimal_attrib)
      attr = form.start.sub(/\A<form /, '').sub(/>\Z/, '').split(/\s+/)
      attr.size.must_equal(minimal_attrib.size + 1)
    end
    
    it "must contain setted method" do
      minimal_attrib[:method] = 'get'
      form = RForm::Form.new(request, minimal_attrib)
      form.start.must_match /\s+method="get"/
      form.start.wont_match /\s+method="post"/
    end
  end
  
  describe "finish" do
    it "must return valid finish tag fo formular" do
      @r_form.finish.must_equal "</form>"
    end
  end
    
  describe "elements" do
    it "must be an array" do
      @r_form.elements.must_be_kind_of Array
    end
  end

  describe "add" do
    it "must have params" do
      err = proc {@r_form.add}.must_raise ArgumentError
      err.message.must_match /wrong number of arguments \(0 for 2\)/
    end

    it "must register an element" do
      @r_form.add :InputTextFixture, :input1
      @r_form.elements.size.must_equal 1
      @r_form.elements[0].must_equal :input1
      @r_form.add :InputTextFixture, :input2
      @r_form.elements.size.must_equal 2
      @r_form.elements[0].must_equal :input1
      @r_form.elements[1].must_equal :input2
    end

    it "must create an element" do
      nspace = 'namespace'
      @r_form.namespace = nspace
      @r_form.add :InputTextFixture, :input1
      @r_form.get(:input1).must_be_kind_of RForm::InputTextFixture
    end
    
    it 'must raise RForm::Error if two IDs of elements are equal' do
      @r_form.add(:InputTextFixture, :input1)
      err = proc { @r_form.add(:InputTextFixture, :input1) }.
        must_raise RForm::Error
      err.message.must_match /ID.+is in using/
    end

    it 'must raise RForm::Error the ID is not a symbol' do
      err = proc { @r_form.add(:InputTextFixture, "input1") }.
        must_raise RForm::Error
      err.message.must_match /ID is not a symbol/
    end
  end

  describe "get" do
    it "must return the from add created objects" do
      @r_form.add :TextAreaFixture, :tarea1
      @r_form.add :InputTextFixture, :input222
      @r_form.elements[0].must_equal :tarea1
      @r_form.elements[1].must_equal :input222
      @r_form.get(:tarea1).must_be_kind_of RForm::TextAreaFixture
    end

    it 'must raise RForm::Error if parameter is not a symbol' do
      err = proc {@r_form.get "tarea1"}.must_raise RForm::Error
      err.message.must_match /not a symbol/
    end
  end


  describe 'sended?' do
    it 'must return false' do
      @r_form.sended?.must_be_kind_of FalseClass
    end
  end

  describe 'data' do
    it 'must return a hash' do
      @r_form.data.must_be_kind_of Hash
    end
  end

  describe 'errors?' do
    it 'must return a false' do
      @r_form.errors?.must_be_kind_of FalseClass
    end  
  end

  describe 'namespace=' do
    it 'must raise an RForm::Error for string containing not allowed chars' do
      err = proc {@r_form.namespace = '~.:;\'%"<>öäüAÄÖÜß?#+\\/§$&()[]^ '}.
        must_raise RForm::Error
      err.message.must_match /not allowed chars/
    end
  end

  describe 'namespace=' do
    it 'must raise an RForm::Error for string containing not allowed chars' do
      err = proc {@r_form.namespace = '~.:;\'%"<>öäüAÄÖÜß?#+\\/§$&()[]^ '}.
        must_raise RForm::Error
      err.message.must_match /not allowed chars/
    end
  end

  describe 'global_nspace=' do
    it 'must do nathing if the request contains no global space params' do
      @r_form.global_nspace = 'global'
      @r_form.elements.size.must_equal 0
    end
  end

  describe 'errors' do
    it 'must return array' do
      @r_form.errors.must_be_kind_of Hash
    end
  end
end
  
describe RForm::Form do
  let(:gnspace) {'global'}
  let(:namespace) {'nspace'}

  let(:valid_attrib) do
    {
      :action => 'any-url',
      :id => 'any-id',
    }
  end

  let :request do
    {
      :post => {
        gnspace => {
          'gn_par1' => 'gn_val1',
          'gn_par2' => 'gn_val2',
        },
        namespace => {
          'ns_par1' => 'ns_val1',
          'ns_par2' => 'ns_val2',
        },
        'par1' => 'val1',
        'par2' => 'val2',
        'par3' => 'val2',
      },
      :get => {
        'g_key1' => 'g_val1',
        'g_key2' => 'g_val2',
        gnspace => {
          'gn_par2' => 'gn_get_val2',
          'gn_par3' => 'gn_get_val3',
        }
      },
    }
  end

  before do
    @form = RForm::Form.new(request, valid_attrib)
  end
  
  describe 'add' do
    it 'must filter post hash for created element by minimal attributes set' do
      @form.add :InputTextFixture, :txt1
      @form.get(:txt1).request.must_equal request[:post]
    end
  end
  
  describe 'add' do
    it 'must filter get hash for created element if method set to get' do
      valid_attrib[:method] = 'get'
      form = RForm::Form.new(request, valid_attrib)
      form.add :InputTextFixture, :txt1
      form.get(:txt1).request.must_equal request[:get]
    end
  end

  describe 'global_nspace=' do
    it 'must create hidden fields if the request contains global space params' do
      @form.global_nspace = gnspace
      @form.elements.size.must_equal 3
      @form.get("hidden_#{gnspace}_gn_par1".to_sym).must_be_kind_of RForm::InputHidden
      @form.get("hidden_#{gnspace}_gn_par2".to_sym).must_be_kind_of RForm::InputHidden
      @form.get("hidden_#{gnspace}_gn_par3".to_sym).must_be_kind_of RForm::InputHidden
      @form.get("hidden_#{gnspace}_gn_par1".to_sym).namespace.must_equal gnspace
      @form.get("hidden_#{gnspace}_gn_par2".to_sym).namespace.must_equal gnspace
      @form.get("hidden_#{gnspace}_gn_par3".to_sym).namespace.must_equal gnspace
      @form.get("hidden_#{gnspace}_gn_par3".to_sym).request.must_equal request[:get].deep_merge(request[:post])
    end
  end

  describe 'data' do
    it 'must return no data hash for form elements' do
      text1 = 'any text'
      text2 = false
      text3 = 'another text'
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).data = text1
      @form.get(:txt_2).data = text2
      @form.get(:txt_3).data = text3
      @form.data.must_equal :txt_1 => text1, :txt_3 => text3
    end
  end

  describe 'errors?' do
    it 'must return false if all elements return false' do
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).error = false
      @form.get(:txt_2).error = false
      @form.get(:txt_3).error = false
      @form.errors?.must_be_kind_of FalseClass 
    end

    it 'must return true if one element returns true' do
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).error = false
      @form.get(:txt_2).error = true
      @form.get(:txt_3).error = false
      @form.errors?.must_be_kind_of TrueClass 
    end
  end

  describe 'errors' do
    it 'must return error messages of elements' do
      msg1 = 'Message 1'
      msg2 = false
      msg3 = "Message 2"
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).error = msg1
      @form.get(:txt_2).error = msg2
      @form.get(:txt_3).error = msg3
      @form.errors.must_equal :txt_1 => msg1, :txt_3 => msg3 
    end
  end

  describe 'sended?' do
    it 'must allways returns false if controls not setted' do
      @form.sended?.must_be_kind_of FalseClass
    end

    it 'must returns true if relevant elements return setted values' do
      msg1 = 'Message 1'
      msg2 = 'Message 2'
      msg3 = "Message 3"
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).data = msg1
      @form.get(:txt_2).data = msg2
      @form.get(:txt_3).data = msg3
      @form.controls = {
        :txt_1 => msg1,
        :txt_2 => msg2,
        :txt_3 => msg3,
      }
      @form.sended?.must_be_kind_of TrueClass
    end

    it 'must return false if one of relevat elements has error' do
      msg1 = 'Message 1'
      msg2 = 'Message 2'
      msg3 = "Message 3"
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).data = msg1
      @form.get(:txt_2).data = msg2
      @form.get(:txt_2).error = true
      @form.get(:txt_3).data = msg3
      @form.controls = {
        :txt_1 => msg1,
        :txt_2 => msg2,
        :txt_3 => msg3,
      }
      @form.sended?.must_be_kind_of FalseClass
    end

    it 'must return false if one of relevat elements has not setted data' do
      msg1 = 'Message 1'
      msg2 = 'Message 2'
      msg3 = "Message 3"
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_2
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).data = msg1
      @form.get(:txt_2).data = "#{msg2} postfix"
      @form.get(:txt_3).data = msg3
      @form.controls = {
        :txt_1 => msg1,
        :txt_2 => msg2,
        :txt_3 => msg3,
      }
      @form.sended?.must_be_kind_of FalseClass
    end

    it 'must return false if one of relevat elements is not setted' do
      msg1 = 'Message 1'
      msg2 = 'Message 2'
      msg3 = "Message 3"
      @form.add :TextAreaFixture, :txt_1
      @form.add :InputTextFixture, :txt_3
      @form.get(:txt_1).data = msg1
      @form.get(:txt_3).data = msg3
      @form.controls = {
        :txt_1 => msg1,
        :txt_2 => msg2,
        :txt_3 => msg3,
      }
      @form.sended?.must_be_kind_of FalseClass
    end
  end
end
