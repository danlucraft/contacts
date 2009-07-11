# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{contacts}
  s.version = "0.2.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\306\222\303\241", "Lukas Fittl", "Keavy Miller"]
  s.date = %q{2009-07-10}
  s.description = %q{TODO}
  s.email = %q{anthonyeden@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/config/contacts.yml",
     "lib/contacts.rb",
     "lib/contacts/flickr.rb",
     "lib/contacts/google.rb",
     "lib/contacts/google_oauth.rb",
     "lib/contacts/version.rb",
     "lib/contacts/windows_live.rb",
     "lib/contacts/yahoo.rb",
     "spec/contact_spec.rb",
     "spec/feeds/contacts.yml",
     "spec/feeds/flickr/auth.getFrob.xml",
     "spec/feeds/flickr/auth.getToken.xml",
     "spec/feeds/google-many.xml",
     "spec/feeds/google-single.xml",
     "spec/feeds/wl_contacts.xml",
     "spec/feeds/yh_contacts.txt",
     "spec/feeds/yh_credential.xml",
     "spec/flickr/auth_spec.rb",
     "spec/gmail/auth_spec.rb",
     "spec/gmail/fetching_spec.rb",
     "spec/rcov.opts",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/windows_live/windows_live_spec.rb",
     "spec/yahoo/yahoo_spec.rb",
     "vendor/fakeweb/CHANGELOG",
     "vendor/fakeweb/LICENSE.txt",
     "vendor/fakeweb/README.rdoc",
     "vendor/fakeweb/Rakefile",
     "vendor/fakeweb/fakeweb.gemspec",
     "vendor/fakeweb/lib/fake_web.rb",
     "vendor/fakeweb/lib/fake_web/ext/net_http.rb",
     "vendor/fakeweb/lib/fake_web/registry.rb",
     "vendor/fakeweb/lib/fake_web/responder.rb",
     "vendor/fakeweb/lib/fake_web/response.rb",
     "vendor/fakeweb/lib/fake_web/socket_delegator.rb",
     "vendor/fakeweb/test/fixtures/test_example.txt",
     "vendor/fakeweb/test/fixtures/test_request",
     "vendor/fakeweb/test/test_allow_net_connect.rb",
     "vendor/fakeweb/test/test_fake_web.rb",
     "vendor/fakeweb/test/test_fake_web_open_uri.rb",
     "vendor/fakeweb/test/test_helper.rb",
     "vendor/fakeweb/test/test_query_string.rb",
     "vendor/windowslivelogin.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aeden/contacts}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby library for consuming Google, Yahoo!, Flickr and Windows Live contact APIs}
  s.test_files = [
    "spec/contact_spec.rb",
     "spec/flickr/auth_spec.rb",
     "spec/gmail/auth_spec.rb",
     "spec/gmail/fetching_spec.rb",
     "spec/spec_helper.rb",
     "spec/windows_live/windows_live_spec.rb",
     "spec/yahoo/yahoo_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
