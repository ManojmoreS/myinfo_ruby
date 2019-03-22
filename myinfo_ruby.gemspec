
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "myinfo_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "myinfo_ruby"
  spec.version       = MyinfoRuby::VERSION
  spec.authors       = ["Manoj More S"]
  spec.email         = ["lettertomanojmore@gmail.com"]

  spec.summary       = %q{Ruby gem for Singapore MyInfo API.}
  spec.description   = %q{Use this to fetch the personal details from MyInfo API.}
  spec.homepage      = "https://github.com/ManojmoreS/myinfo_ruby"
  spec.license       = "MIT"
  spec.files         = Dir['{app,config,lib}/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'jose', '~> 1.1', '>= 1.1.0'
  spec.add_development_dependency "rest-client", "2.0"
  spec.required_ruby_version = '>= 2.0.0'
end
