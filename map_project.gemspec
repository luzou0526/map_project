$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "map_project/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "map_project"
  s.version     = MapProject::VERSION
  s.authors     = ["Lu Zou"]
  s.email       = ["luxizou.web@gmail.com"]
  s.homepage    = "https://github.com/luzou0526/map_project"
  s.summary     = "Tools converting geo latlng to viewport position."
  s.description = "Gem provides a way to calculate zoom level using boudary, and get the html viewport coords for map locations"
  s.license     = "MIT"
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
  s.add_dependency "rails", "~> 4.2.6"
  s.add_development_dependency "sqlite3"
end
