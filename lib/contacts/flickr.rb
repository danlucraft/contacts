require 'contacts'

require 'flickr_fu'

module Contacts
  
  class Flickr

    CONFIG_FILE = File.dirname(__FILE__) + '/../config/contacts.yml'

    def initialize(config_file=CONFIG_FILE)
      confs = YAML.load_file(config_file)['flickr']
      @appid= confs['appid']
      @secret= confs['secret']
    end    

    def get_authentication_url
      ::Flickr.new({:key => @appid, :secret => @secret}).auth.url
    end

    def contacts(token)
      ::Flickr.new({:key => @appid, :secret => @secret, :token => token}).contacts
    end
  end 
end
