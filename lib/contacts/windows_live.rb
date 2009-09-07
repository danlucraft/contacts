require 'contacts'

require File.join(File.dirname(__FILE__), %w{.. .. vendor windowslivelogin})
require 'hpricot'
require 'uri'

module Contacts
  # = How I can fetch Windows Live Contacts?
  # To gain access to a Windows Live user's data in the Live Contacts service, 
  # a third-party developer first must ask the owner for permission. You must
  # do that through Windows Live Delegated Authentication.
  # 
  # This library give you access to Windows Live Delegated Authentication System
  # and Windows Live Contacts API. Just follow the steps below and be happy!
  # 
  # === Registering your app
  # First of all, follow the steps in this 
  # page[http://msdn.microsoft.com/en-us/library/cc287659.aspx] to register your
  # app.
  # 
  # === Configuring your Windows Live YAML
  # After registering your app, you will have an *appid*, a <b>secret key</b> and
  # a <b>return URL</b>. Use their values to fill in the config/contacts.yml file.
  # The policy URL field inside the YAML config file must contain the URL 
  # of the privacy policy of your Web site for Delegated Authentication.
  # 
  # === Authenticating your user and fetching his contacts
  # 
  #   wl = Contacts::WindowsLive.new
  #   auth_url = wl.get_authentication_url
  # 
  # Use that *auth_url* to redirect your user to Windows Live. He will authenticate
  # there and Windows Live will POST to your return URL. You have to get the
  # body of that POST, let's call it post_body. (if you're using Rails, you can 
  # get the POST body through request.raw_post, in the context of an action inside
  # ActionController)
  #
  # Now, to fetch his contacts, just do this:
  #
  #   contacts = wl.contacts(post_body)
  #   #-> [ ['Fitzgerald', 'fubar@gmail.com', 'fubar@example.com'],
  #         ['William Paginate', 'will.paginate@gmail.com'], ...
  #       ]
  #--
  # This class has two responsibilities:
  # 1. Access the Windows Live Contacts API through Delegated Authentication
  # 2. Import contacts from Windows Live and deliver it inside an Array
  #
  class WindowsLive
    
    attr_accessor :wll
    # Initialize a new WindowsLive object.
    #    
    # ==== Paramaters
    # * config_file <String>:: The contacts YAML config file name
    #--
    # You can check an example of a config file inside config/ directory
    #
    def initialize(config_file)
      confs = YAML.load_file(config_file)['windows_live']
      @wll = WindowsLiveLogin.new(confs['appid'], confs['secret'], confs['security_algorithm'],
                                  nil, confs['policy_url'], confs['return_url'])
    end


    # Windows Live Contacts API need to authenticate the user that is giving you
    # access to his contacts. To do that, you must give him a URL. That method
    # generates that URL. The user must access that URL, and after he has done
    # authentication, hi will be redirected to your application.
    #
    def get_authentication_url(context=nil)
      @wll.getConsentUrl("Contacts.View", context)
    end
    
    # After the user has been authenticaded, Windows Live Delegated Authencation
    # Service redirects to your application, through a POST HTTP method. Along
    # with the POST, Windows Live send to you a Consent that you must process
    # to access the user's contacts. This method process the Consent 
    # to you.
    #
    # ==== Paramaters
    # * consent <String>:: A string containing the Consent given to you inside
    # the redirection POST from Windows Live
    #
    def process_consent(consent)
      consent.strip!
      consent = URI.unescape(consent)
      @consent_token = @wll.processConsent(consent)
    end
    
    def process_consent_token(consent_token)
      @wll.processConsentToken consent_token
    end
        
    # This method return the user's contacts inside an Array in the following
    # format:
    #
    #   [ 
    #     ['Brad Fitzgerald', 'fubar@gmail.com'],
    #     [nil, 'nagios@hotmail.com'],
    #     ['William Paginate', 'will.paginate@yahoo.com']  ...
    #   ]
    #
    # ==== Paramaters
    # * consent <String>:: A string containing the Consent given to you inside 
    # the redirection POST from Windows Live
    #
    def contacts(consent)
      if consent.is_a? WindowsLiveLogin::ConsentToken
        @consent_token = consent
      else
        process_consent(consent)
      end
      contacts_xml = access_live_contacts_api()
      contacts_list = WindowsLive.parse_xml(contacts_xml)
    end

    # This method access the Windows Live Contacts API Web Service to get
    # the XML contacts document
    #
    def access_live_contacts_api
      http = http = Net::HTTP.new('livecontacts.services.live.com', 443)
      http.use_ssl = true

      response = nil
      http.start do |http|
         request = Net::HTTP::Get.new("/users/@L@#{@consent_token.locationid}/rest/LiveContacts", {"Authorization" => "DelegatedToken dt=\"#{@consent_token.delegationtoken}\""})
         response = http.request(request)
      end
      response.body
    end
    
    # This method parses the XML Contacts document and returns the contacts
    # inside an Array
    #
    # ==== Paramaters
    # * xml <String>:: A string containing the XML contacts document
    #
    def self.parse_xml(xml)
      doc = Hpricot::XML(xml)
      contacts = []
      doc.search('/LiveContacts/Contacts/Contact') do |contact|
        
          contact_id = text_value contact, "ID"
          
          first_name = text_value contact, "Profiles/Personal/FirstName"
          last_name  = text_value contact, "Profiles/Personal/LastName"
          name = "#{first_name} #{last_name}".strip
          emails     = contact.search('Emails/Email').collect {|e| text_value e, "Address"}
          
          phones     = contact.search('Phones/Phone').collect do |e| 
            type=convert_type(text_value(e, "PhoneType"))
            { "type" => type, "value" => (text_value e, "Number") }
          end
          
          addresses = contact.search('Locations/Location').collect do |e|
            street       = text_value(e, "StreetLine")
            postal_code  = text_value(e, "PostalCode")
            sub_division = text_value(e, "Subdivision")
            city         = text_value(e, "PrimaryCity")
            country_code = text_value(e, "CountryRegion")
            formatted    = [street, city, sub_division, postal_code, country_code].compact.join(", ")
            type         = convert_type(text_value(e, "LocationType"))
            { "formatted" => formatted, "type" => type, "streetAddress" => street, "locality" => city, "region" => sub_division, "postalCode" => postal_code, "country" => country_code}
          end

          new_contact = Contact.new(nil, name, nil, first_name, last_name)
          new_contact.emails      = emails
          new_contact.phones      = phones
          new_contact.addresses   = addresses
          new_contact.service_id  = contact_id
          contacts << new_contact
      end  
      return contacts
    end
    
    def self.text_value(elem,path)
      elem.at(path).inner_text rescue nil
    end
    
    def self.convert_type(t)
      {"personal" => "home", "business" => "work"}[t.downcase] || "other"
    end
  end

end
