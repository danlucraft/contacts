require 'contacts'

begin
  require 'flickr_fu'
rescue LoadError => error
  puts "~> contacts/flickr: Could not load flickr_fu gem."
  puts "~> contacts/flickr: Install it with `gem install flickr_fu'."
  exit -1
end

module Contacts
  
  class Flickr

    attr_accessor :token

    def initialize(config_file)
      confs = YAML.load_file(config_file)['flickr']
      @appid= confs['appid']
      @secret= confs['secret']
    end    

    def get_authentication_url
      ::Flickr.new({:key => @appid, :secret => @secret}).auth.url
    end

    def contacts(frob= nil)
      client(frob).contacts.get_list
    end

    def client(frob= nil)
      @token  ||= get_token(frob) unless frob.nil?
      @client ||= ::Flickr.new({:key => @appid, :secret => @secret, :token => @token.token})
    end

    # returns a Flickr::Token
    def get_token(frob)
      client= ::Flickr.new({:key => @appid, :secret => @secret})
      client.auth.frob= frob
      client.auth.token
    end

  end
end
