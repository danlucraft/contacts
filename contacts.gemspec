# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{contacts}
  s.version = "0.2.20"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\306\222\303\241", "Lukas Fittl", "Keavy Miller", "Aurelian Oancea"]
  s.date = %q{2009-09-07}
  s.description = %q{TODO}
  s.email = %q{oancea@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/contacts.rb",
     "lib/contacts/flickr.rb",
     "lib/contacts/google.rb",
     "lib/contacts/google_oauth.rb",
     "lib/contacts/version.rb",
     "lib/contacts/windows_live.rb",
     "lib/contacts/yahoo.rb",
     "vendor/windowslivelogin.rb"
  ]
  s.homepage = %q{http://github.com/aurelian/contacts}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
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
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
