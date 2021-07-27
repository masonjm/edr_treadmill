require_relative "lib/edr_treadmill/version"

Gem::Specification.new do |spec|
  spec.name          = "edr_treadmill"
  spec.version       = EdrTreadmill::VERSION
  spec.authors       = ["James Mason"]
  spec.email         = ["masonjm@gmail.com"]

  spec.summary       = "Excersize your EDRs"
  spec.description   = "Command-line utility to generate activity for EDR verification"
  spec.homepage      = "https://github.com/masonjm/edr_treadmill"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
