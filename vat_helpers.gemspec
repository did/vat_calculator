Gem::Specification.new do |s|
  s.name = "vat_helpers"
  s.summary = "Various helpers (Validator for ActiveModel, VTA rate) for european countries VAT numbers"
  s.description = "Various helpers (Validator for ActiveModel, VTA rate) for european countries VAT numbers"
  s.homepage = "http://github.com/did/vat_helpers"

  s.version = "1.2"
  s.date = "2011-05-12"

  s.authors = ["Aurélien Malisart", "Didier Lafforgue"]
  s.email = ["aurelien.malisart@gmail.com", "didier@nocoffee.fr"]

  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"] + Dir["spec/**/*"] + ["README.rdoc", "Rakefile"]
  s.extra_rdoc_files = ["README.rdoc"]

  s.has_rdoc = false

  s.rubygems_version = "1.3.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6")

  s.add_dependency 'soap'
  s.add_dependency 'soap4r'
end