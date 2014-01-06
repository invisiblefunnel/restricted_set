# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "restricted_set"
  spec.version       = "1.0.0"
  spec.authors       = ["Danny Whalen"]
  spec.email         = ["daniel.r.whalen@gmail.com"]
  spec.description   = %q{Sets with conditional membership defined by a given block.}
  spec.summary       = <<-SUMMARY.gsub(/\n/, ' ').strip
RestricedSet implements a set with restrictions defined by a given block.
If the block's arity is 2, it is called with the RestrictedSet itself and
an object to see if the object is allowed to be put in the set. Otherwise,
the block is called with an object to see if the object is allowed to be
put in the set.
  SUMMARY
  spec.homepage      = "https://github.com/invisiblefunnel/restricted_set"
  spec.license       = "2-clause BSDL"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
end
