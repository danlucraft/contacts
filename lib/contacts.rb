require 'contacts/version'

module Contacts
  
  Identifier = 'Ruby Contacts v' + VERSION::STRING
  
  # An object that represents a single contact
  class Contact
    attr_reader   :organizations, :firstname, :lastname
    attr_accessor :name, :username, :service_id, :note, :emails, :ims,:phones, :addresses
    
    def initialize(email, name = nil, username = nil, firstname = nil, lastname = nil)
      @emails = []
      @emails << email if email
      @ims = []
      @phones = []
      @addresses = []
      @organizations = []
      @name = name
      @username = username
      @firstname = firstname
      @lastname = lastname
    end
    
    def email
      @emails.first
    end
    
    def inspect
      %!#<Contacts::Contact "#{name}"#{email ? " (#{email})" : ''}>!
    end
  end

  def self.verbose=(verbose)
    @verbose = verbose
  end
  
  def self.verbose?
    @verbose || 'irb' == $0
  end
  
  class Error < StandardError
  end
  
  class TooManyRedirects < Error
    attr_reader :response, :location
    
    MAX_REDIRECTS = 2
    
    def initialize(response)
      @response = response
      @location = @response['Location']
      super "exceeded maximum of #{MAX_REDIRECTS} redirects (Location: #{location})"
    end
  end
  
end
