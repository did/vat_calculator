Gem::Specification.new do |s|
  s.name = "vat_calculator"
  s.summary = "Helper to calculate the VAT rate"
  s.description = "Helper to calculate the VAT rate"
  s.homepage = "http://github.com/did/vat_calculator"

  s.version = "1.2.1"
  s.date = "2011-05-12"

  s.authors = ["Didier Lafforgue"]
  s.email = "didier@nocoffee.fr"

  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"] + Dir["spec/**/*"] + ["README.rdoc", "Rakefile"]
  s.extra_rdoc_files = ["README.rdoc"]

  s.has_rdoc = false

  s.rubygems_version = "1.3.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6")

  s.add_dependency 'activesupport'
  s.add_dependency 'vat_validator'
end