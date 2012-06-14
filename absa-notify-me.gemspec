# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "absa-notify-me/version"

Gem::Specification.new do |s|
  s.name        = "absa-notify-me"
  s.version     = Absa::NotifyMe::VERSION
  s.authors     = ["Jeffrey van Aswegen, Douglas Anderson"]
  s.email       = ["jeffmess@gmail.com, i.am.douglas.anderson@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A ruby interface to commumicate with the ABSA Notify Me Statement Delivery platform.}
  s.description = %q{
    This is just a rapidly prototyped proof of concept gem for 
    bankserv gem and those who can afford to use the ABSA NotifyMe 
    Platform. 
    
    For a production ready gem please rather use absa-esd with the 
    bankserv gem 
    
    https://github.com/tehtorq/absa-esd
    https://github.com/jeffmess/Bankserv
  }

  s.rubyforge_project = "absa-notify-me"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "nori"
  s.add_dependency "nokogiri"
end
