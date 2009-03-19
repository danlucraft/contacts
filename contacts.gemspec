# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{contacts}
  s.version = "0.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\306\222\303\241", "Lukas Fittl", "Keavy Miller"]
  s.date = %q{2009-03-19}
  s.description = %q{TODO}
  s.email = %q{keavy@minimetre.com}
  s.files = ["MIT-LICENSE", "Rakefile", "README.rdoc", "VERSION.yml", "lib/config", "lib/config/contacts.yml", "lib/contacts", "lib/contacts/flickr.rb", "lib/contacts/google.rb", "lib/contacts/google_oauth.rb", "lib/contacts/version.rb", "lib/contacts/windows_live.rb", "lib/contacts/yahoo.rb", "lib/contacts.rb", "spec/contact_spec.rb", "spec/feeds", "spec/feeds/contacts.yml", "spec/feeds/flickr", "spec/feeds/flickr/auth.getFrob.xml", "spec/feeds/flickr/auth.getToken.xml", "spec/feeds/google-many.xml", "spec/feeds/google-single.xml", "spec/feeds/wl_contacts.xml", "spec/feeds/yh_contacts.txt", "spec/feeds/yh_credential.xml", "spec/flickr", "spec/flickr/auth_spec.rb", "spec/gmail", "spec/gmail/auth_spec.rb", "spec/gmail/fetching_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb", "spec/windows_live", "spec/windows_live/windows_live_spec.rb", "spec/yahoo", "spec/yahoo/yahoo_spec.rb", "vendor/fakeweb", "vendor/windowslivelogin.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/keavy/contacts}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
