$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "map_project/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "map_project"
  s.version     = MapProject::VERSION
  s.authors     = ["Lu Zou"]
  s.email       = ["Lu.Zou@move.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MapProject."
  s.description = "TODO: Description of MapProject."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
end
