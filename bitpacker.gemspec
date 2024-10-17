# frozen_string_literal: true

require_relative "lib/bitpacker/version"

Gem::Specification.new do |spec|
  spec.name = "bitpacker"
  spec.version = BitPacker::VERSION
  spec.authors = ["Chris AtLee"]
  spec.email = ["chris@atlee.ca"]

  spec.summary = "Efficient packing of integers"
  spec.description = "Based on rust crate bitpacking"
  spec.homepage = "https://github.com/catlee/bitpacker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/catlee/bitpacker/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.extensions = ["ext/bitpacker/extconf.rb"]

  # needed until rubygems supports Rust support is out of beta
  spec.add_dependency "rb_sys", "~> 0.9.39"
end
