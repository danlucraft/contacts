require 'spec_helper'
require 'contacts'

describe Contacts::Contact do
  describe 'instance' do
    before do
      @contact = Contacts::Contact.new('max@example.com', 'Max Power', 'maxpower')
    end
    
    it "should have email" do
      @contact.email.should == 'max@example.com'
    end
    
    it "should have name" do
      @contact.name.should == 'Max Power'
    end
    
    it "should support multiple emails" do
      @contact.emails << 'maxpower@example.com'
      @contact.email.should == 'max@example.com'
      @contact.emails.should == ['max@example.com', 'maxpower@example.com']
    end
    
    it "should support multiple ims" do
      @contact.ims << {'value' => 'max', 'type' => 'skype'}
      @contact.ims.should == [{'value' => 'max', 'type' => 'skype'}]
    end
    
    it "should support multiple phones" do
      @contact.phones << {'value' => '111 111 1111', 'type' => 'home'}
      @contact.phones.should == [{'value' => '111 111 1111', 'type' => 'home'}]
    end
    
    it "should support multiple addresses" do
      @contact.addresses << {'formatted' => '111 SW 1st Street, New York, NY'}
      @contact.addresses.should == [{'formatted' => '111 SW 1st Street, New York, NY'}]
    end
    
    it "should have username" do
      @contact.username.should == 'maxpower'
    end
  end
  
  describe '#inspect' do
    it "should be nice" do
      @contact = Contacts::Contact.new('max@example.com', 'Max Power', 'maxpower')
      @contact.inspect.should == '#<Contacts::Contact "Max Power" (max@example.com)>'
    end
    
    it "should be nice without email" do
      @contact = Contacts::Contact.new(nil, 'Max Power', 'maxpower')
      @contact.inspect.should == '#<Contacts::Contact "Max Power">'
    end
  end
  
end
