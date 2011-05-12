$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require(:test)

require 'mocha'
require 'rspec'
require 'vat_helpers'

Rspec.configure do |config|
  config.mock_with :mocha
end

# Utils models =================================================================

class BaseTestModel
  include ActiveModel::Serialization
  include ActiveModel::Validations

  attr_accessor :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end
end

class Invoice < BaseTestModel
  validates :vat_number, :vat => true
end

class OptionalVatInvoice < BaseTestModel
  validates :vat_number, :vat => true, :allow_blank => true
end

class CountryCheckedInvoice < BaseTestModel
  validates :vat_number, :vat => { :country_method => :country_code }

  # Fake attribute accessor
  def country
    @attributes[:country]
  end

  # Logic to return the country code
  def country_code
    case country.downcase
      when 'belgium' then 'BE'
      when 'france'  then 'FR'
      when 'sweden'  then 'SE'
      else nil
    end
  end
end

class ViesCheckedInvoice < BaseTestModel
  validates :vat_number, :vat => {:vies => true}
end