require 'contacts'

require 'rubygems'
require 'hpricot'
require 'md5'
require 'net/https'
require 'uri'
require 'yaml'
require 'json'

module Contacts
  # = How I can fetch Yahoo Contacts?
  # To gain access to a Yahoo user's data in the Yahoo Address Book Service, 
  # a third-party developer first must ask the owner for permission. You must
  # do that through Yahoo Browser Based Authentication (BBAuth).
  # 
  # This library give you access to Yahoo BBAuth and Yahoo Address Book API. 
  # Just follow the steps below and be happy!
  # 
  # === Registering your app
  # First of all, follow the steps in this 
  # page[http://developer.yahoo.com/wsregapp/] to register your app. If you need
  # some help with that form, you can get it
  # here[http://developer.yahoo.com/auth/appreg.html]. Just two tips: inside
  # <b>Required access scopes</b> in that registration form, choose
  # <b>Yahoo! Address Book with Read Only access</b>. Inside 
  # <b>Authentication method</b> choose <b>Browser Based Authentication</b>.
  #
  # === Configuring your Yahoo YAML
  # After registering your app, you will have an <b>application id</b> and a
  # <b>shared secret</b>. Use their values to fill in the config/contacts.yml 
  # file.
  #
  # === Authenticating your user and fetching his contacts
  # 
  #   yahoo = Contacts::Yahoo.new
  #   auth_url = yahoo.get_authentication_url
  # 
  # Use that *auth_url* to redirect your user to Yahoo BBAuth. He will authenticate
  # there and Yahoo will redirect to your application entrypoint URL (that you provided
  # while registering your app with Yahoo). You have to get the path of that 
  # redirect, let's call it path (if you're using Rails, you can get it through
  # request.request_uri, in the context of an action inside ActionController)
  #
  # Now, to fetch his contacts, just do this:
  #
  #   contacts = wl.contacts(path)
  #   #-> [ ['Fitzgerald', 'fubar@gmail.com', 'fubar@example.com'],
  #         ['William Paginate', 'will.paginate@gmail.com'], ...
  #       ]
  #--
  # This class has two responsibilities:
  # 1. Access the Yahoo Address Book API through Delegated Authentication
  # 2. Import contacts from Yahoo Mail and deliver it inside an Array
  #
  class Yahoo
    AUTH_DOMAIN = "https://api.login.yahoo.com"
    AUTH_PATH = "/WSLogin/V1/wslogin?appid=#appid&ts=#ts"
    CREDENTIAL_PATH = "/WSLogin/V1/wspwtoken_login?appid=#appid&ts=#ts&token=#token"
    ADDRESS_BOOK_DOMAIN = "address.yahooapis.com"
    ADDRESS_BOOK_PATH = "/v1/searchContacts?format=json&fields=all&appid=#appid&WSSID=#wssid"
    CONFIG_FILE = File.dirname(__FILE__) + '/../config/contacts.yml'

    attr_reader :appid, :secret, :token, :wssid, :cookie
    
    # Initialize a new Yahoo object.
    #    
    # ==== Paramaters
    # * config_file <String>:: The contacts YAML config file name
    #--
    # You can check an example of a config file inside config/ directory
    #
    def initialize(config_file=CONFIG_FILE)
      confs = YAML.load_file(config_file)['yahoo']
      @appid = confs['appid']
      @secret = confs['secret']
    end

    # Yahoo Address Book API need to authenticate the user that is giving you
    # access to his contacts. To do that, you must give him a URL. This method
    # generates that URL. The user must access that URL, and after he has done
    # authentication, hi will be redirected to your application.
    #
    def get_authentication_url(appdata= nil)
      path = AUTH_PATH.clone
      path.sub!(/#appid/, @appid)

      timestamp = Time.now.utc.to_i
      path.sub!(/#ts/, timestamp.to_s)

      path<< "&appdata=#{appdata}" unless appdata.nil?
      
      signature = MD5.hexdigest(path + @secret)
      return AUTH_DOMAIN + "#{path}&sig=#{signature}"
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
    # * path <String>:: The path of the redirect request that Yahoo sent to you
    # after authenticating the user
    #
    def contacts(token)
      begin
        if token.is_a?(YahooToken)
          @token = token.token
        else
          validate_signature(token)
        end
        credentials = access_user_credentials()
        parse_credentials(credentials)
        contacts_json = access_address_book_api()
        Yahoo.parse_contacts(contacts_json)
      rescue Exception => e
        "Error #{e.class}: #{e.message}."
      end
    end

    # This method processes and validates the redirect request that Yahoo send to
    # you. Validation is done to verify that the request was really made by
    # Yahoo. Processing is done to get the token.
    #
    # ==== Paramaters
    # * path <String>:: The path of the redirect request that Yahoo sent to you
    # after authenticating the user
    #
    def validate_signature(path)
      path.match(/^(.+)&sig=(\w{32})$/)
      path_without_sig = $1
      sig = $2

      if sig == MD5.hexdigest(path_without_sig + @secret)
        path.match(/token=(.+?)&/)
        @token = $1
        return true
      else
        raise 'Signature not valid. This request may not have been sent from Yahoo.'
      end
    end

    # This method accesses Yahoo to retrieve the user's credentials.
    #
    def access_user_credentials
      url = get_credential_url()
      uri = URI.parse(url)

      http = http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      response = nil
      http.start do |http|
         request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
         response = http.request(request)
      end

      return response.body
    end

    # This method generates the URL that you must access to get user's
    # credentials.
    #
    def get_credential_url
      path = CREDENTIAL_PATH.clone
      path.sub!(/#appid/, @appid)

      path.sub!(/#token/, @token)

      timestamp = Time.now.utc.to_i
      path.sub!(/#ts/, timestamp.to_s)

      signature = MD5.hexdigest(path + @secret)
      return AUTH_DOMAIN + "#{path}&sig=#{signature}"
    end

    # This method parses the user's credentials to generate the WSSID and 
    # Coookie that are needed to give you access to user's address book.
    #
    # ==== Paramaters
    # * xml <String>:: A String containing the user's credentials
    #
    def parse_credentials(xml)
      doc = Hpricot::XML(xml)
      @wssid = doc.at('/BBAuthTokenLoginResponse/Success/WSSID').inner_text.strip
      @cookie = doc.at('/BBAuthTokenLoginResponse/Success/Cookie').inner_text.strip
    end

    # This method accesses the Yahoo Address Book API and retrieves the user's
    # contacts in JSON.
    #
    def access_address_book_api
      http = http = Net::HTTP.new(ADDRESS_BOOK_DOMAIN, 80)

      response = nil
      http.start do |http|
         path = ADDRESS_BOOK_PATH.clone
         path.sub!(/#appid/, @appid)
         path.sub!(/#wssid/, @wssid)

         request = Net::HTTP::Get.new(path, {'Cookie' => @cookie})
         response = http.request(request)
      end

      return response.body
    end
    
    # This method parses the JSON contacts document and returns an array
    # contaning all the user's contacts.
    #
    # ==== Parameters
    # * json <String>:: A String of user's contacts in JSON format
    # "fields": [
    #    {
    #        "type": "phone",
    #        "data": "808 123 1234",
    #        "home": true,
    #    },
    #    {
    #        "type": "email",
    #        "data": "martin.berner@mail.com",
    #    },
    #    
    #    {
    #        "type": "otherid",
    #        "data": "windowslive@msn.com",
    #        "msn":  true,
    #    }
    #  ]
    #  
    def self.parse_contacts(json)
      contacts = []
      people = JSON.parse(json)

      people['contacts'].each do |contact|
        name = nil
        email = nil
        firstname = nil
        lastname = nil
        
        contact_fields=Yahoo.array_to_hash contact['fields']

        emails    = (contact_fields['email'] || []).collect {|e| e['data']}
        ims       = (contact_fields['otherid'] || []).collect { |im| get_type_value(im) }
        phones    = (contact_fields['phone'] || []).collect { |phone| get_type_value(phone) }
        addresses = (contact_fields['address'] || []).collect do |address| 
          type=get_type(address)
          type = {"home" => "home", "work" => "work"}[type.downcase] || "other"
          value = [address['street'], address['city'], address['state'], address['zip'], address['country']].compact.join(", ")
          {"type" => type, "value" => value}
        end
        
        name_field=(contact_fields['name'] || [])
        
        # if name is blank, try go for the yahoo id, and if that's blank too, ignore the record altogether (probably a mailing list)
        if (name_field.empty?)
          if contact_fields['yahooid']
            name = contact_fields['yahooid'][0]['data']
          else
            next
          end
        else
          name_field = name_field[0]
          name = "#{name_field['first']} #{name_field['last']}"
          name.strip!
          lastname = name_field['last']
          firstname = name_field['first']
        end
        
        yahoo_contact            = Contact.new(nil, name, nil, firstname, lastname)
        yahoo_contact.emails     = emails
        yahoo_contact.ims        = ims
        yahoo_contact.phones     = phones
        yahoo_contact.addresses  = addresses
        yahoo_contact.service_id = contact['cid']

        contacts.push yahoo_contact
      end
      return contacts
    end
    
    #
    # grab the type field from each array item 
    #   and turn it into a "email"=>{}, "phone"=>{} array
    #
    private 
    def self.array_to_hash(a)
      (a || []).inject({}) {|x,y|
        x[y['type']] ||= []
        x[y['type']] << y
        x
      }
    end

    #
    # return type/value from a datastructure like
    # {
    #   "data": "808 456 7890",
    #   "mobile": true
    # }
    # -----> "type"=>"mobile", "value"=>"808 456 7890"
    #
    def self.get_type_value(hash)
      type_field = hash.find{ |x| x[1] == true }
      type = type_field  ? type_field[0] : nil
      {"type" => type, "value" => hash["data"]}
    end
    
    #
    # return just the type from a datastructure like
    # {
    #   "data": "808 456 7890",
    #   "mobile": true
    # }
    # -----> "mobile"
    #
    def self.get_type(hash)
      type_field = hash.find{ |x| x[1] == true }
      type = type_field  ? type_field[0] : nil
    end

  end
  class YahooToken
    attr_reader :token
    def initialize(token)
      @token = token
    end
  end
end
