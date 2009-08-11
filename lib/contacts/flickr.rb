require 'contacts'

begin
  require 'flickr_fu'
rescue LoadError => error
  $LOAD_PATH<< File.dirname(__FILE__) + '/../../vendor/flickr_fu/lib'
  require 'flickr_fu'
end

module Contacts
  
  class Flickr

    CONFIG_FILE = File.dirname(__FILE__) + '/../config/contacts.yml'

    attr_accessor :token

    def initialize(config_file=CONFIG_FILE)
      confs = YAML.load_file(config_file)['flickr']
      @appid= confs['appid']
      @secret= confs['secret']
    end    

    def get_authentication_url
      ::Flickr.new({:key => @appid, :secret => @secret}).auth.url
    end

    def contacts(frob= nil)
      @token ||= get_token(frob) unless frob.nil?
      ::Flickr.new({:key => @appid, :secret => @secret, :token => @token.token}).contacts.get_list
    end

    # returns a Flickr::Token
    def get_token(frob)
      client= ::Flickr.new({:key => @appid, :secret => @secret})
      client.auth.frob= frob
      client.auth.token
    end

  end
end
