require 'contacts'

require 'flickr_fu'

module Contacts

  class FlickrFu

    def initialize(config_file=CONFIG_FILE)
      confs = YAML.load_file(config_file)['flick_fu']
      @appid = confs['appid']
      @secret = confs['secret']
    end    

    def get_authentication_url(appdata= nil)
    end

    def contacts(token)
    end
  end

end
