# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{contacts}
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\304\207"]
  s.date = %q{2009-01-21}
  s.description = %q{Ruby library for consuming Google, Yahoo!, Flickr and Windows Live contact APIs}
  s.email = %q{mislav.marohnic@gmail.com}
  s.extra_rdoc_files = ["lib/config/contacts.yml", "lib/contacts/flickr.rb", "lib/contacts/google.rb", "lib/contacts/version.rb", "lib/contacts/windows_live.rb", "lib/contacts/yahoo.rb", "lib/contacts.rb", "README.rdoc"]
  s.files = ["contacts.gemspec", "lib/config/contacts.yml", "lib/contacts/flickr.rb", "lib/contacts/google.rb", "lib/contacts/version.rb", "lib/contacts/windows_live.rb", "lib/contacts/yahoo.rb", "lib/contacts.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "spec/contact_spec.rb", "spec/feeds/contacts.yml", "spec/feeds/flickr/auth.getFrob.xml", "spec/feeds/flickr/auth.getToken.xml", "spec/feeds/google-many.xml", "spec/feeds/google-single.xml", "spec/feeds/wl_contacts.xml", "spec/feeds/yh_contacts.txt", "spec/feeds/yh_credential.xml", "spec/flickr/auth_spec.rb", "spec/gmail/auth_spec.rb", "spec/gmail/fetching_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb", "spec/windows_live/windows_live_spec.rb", "spec/yahoo/yahoo_spec.rb", "vendor/windowslivelogin.rb"]
  s.has_rdoc = true
  s.homepage = %q{git://github.com/tamoyal/contacts.git}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Contacts", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{contacts}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby library for consuming Google, Yahoo!, Flickr and Windows Live contact APIs}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
