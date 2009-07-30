# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{method_call_recorder}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Evans"]
  s.date = %q{2009-07-31}
  s.email = %q{mark@new-bamboo.co.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/method_call_recorder.rb",
     "lib/method_call_recorder/method_call.rb",
     "lib/method_call_recorder/method_call_logger.rb",
     "lib/method_call_recorder/method_call_recorder.rb",
     "method_call_recorder.gemspec",
     "spec/method_call_logger_spec.rb",
     "spec/method_call_recorder_spec.rb",
     "spec/method_call_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/markevans/method_call_recorder}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An object on which you can call anything, where nothing happens, but the whole method chain is recorded}
  s.test_files = [
    "spec/method_call_logger_spec.rb",
     "spec/method_call_recorder_spec.rb",
     "spec/method_call_spec.rb",
     "spec/spec_helper.rb"
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
