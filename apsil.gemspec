require_relative "lib/apsil/version"

Gem::Specification.new do |spec|
  spec.name = "apsil"
  spec.version = "0.0.0"
  spec.authors = ["F-3r"]
  spec.email = ["F-3r@nonono.no"]

  spec.summary       = %q{Postcript-inspired stack-based toy-language}
  spec.description   = %q{Postcript-inspired stack-based toy-language}
  spec.homepage = "https://github.com/f-3r/apsil"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/f-3r/apsil"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "reline"
end
