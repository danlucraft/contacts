require 'spec_helper'
require 'contacts/windows_live'

describe Contacts::WindowsLive do

  before(:each) do
    @path = Dir.getwd + '/spec/feeds/'
    @wl = Contacts::WindowsLive.new(@path + 'contacts.yml')
  end
  
  it 'parse the XML contacts document' do
    contacts = Contacts::WindowsLive.parse_xml(contacts_xml)
    contacts.size.should == 2
    contacts[0].name.should == "Mia Pia"
    contacts[0].firstname.should == "Mia"
    contacts[0].lastname.should == "Pia"
    contacts[0].emails.should include("mia@hotmail.com", "othermia@yahoo.com")
    contacts[0].phones.should include({"value"=>"(123) 123 1234", "type"=>"home"}, {"value"=>"(321) 555 1234", "type"=>"other"})
    contacts[0].addresses.should include({"region"=>"CA", "country"=>"USA", "postalCode"=>"92123", "streetAddress"=>"123 Green St", "type"=>"home", "locality"=>"Middleville", "formatted"=>"123 Green St, Middleville, CA, 92123, USA"})
    
    contacts[1].name.should == ""
    contacts[1].firstname.should == nil
    contacts[1].lastname.should == nil
    contacts[1].emails.should include("marcus@hotmail.com")
    contacts[1].phones.should be_empty
    contacts[1].addresses.should be_empty
  end

  it 'should can be initialized by a YAML file' do
    wll = @wl.instance_variable_get('@wll')

    wll.appid.should == 'your_app_id'
    wll.securityalgorithm.should == 'wsignin1.0'
    wll.returnurl.should == 'http://yourserver.com/your_return_url'
  end

  def contacts_xml
    File.open(@path + 'wl_full_contacts.xml', 'r+').read
  end
end
