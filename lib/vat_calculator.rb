require 'ostruct'
require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/attribute_accessors'

module VatCalculator

  DEFAULT_BASE_COUNTRY  = 'FR'

  mattr_accessor :base_country

  mattr_accessor :current_rate_rule

  EUROPEAN_COUNTRIES = %w(DE AT BE BG CY DK ES EE FI FR EL HU IE IT LV LT LU MT NL PL GB RO SK SI SE CZ)

  VAT_RATES = {
    'FR'      => {
      :rate         => 19.6,
      :exceptions   => {
        'GF'  => 0.0,     # French Guyana
        'GP'  => 8.5,     # Guadeloupe
        'MQ'  => 8.5,     # Martinique
        'RE'  => 8.5      # Réunion
      }
    },

    'GP'      => 8.5,
    'MQ'      => 8.5,
    'RE'      => 8.5,

    'BE'      => 21
  }

  def self.formalize_rate_rule(data)
    unless data.is_a?(Hash)
      data = { :rate => data.to_f }
    end

    OpenStruct.new({
      :exceptions         => {},
      :rate               => 0.0,
      :no_rate            => 0.0
    }.merge(data))
  end

  class NoCountryException < Exception; end

  class NoRuleFoundException < Exception; end

  # Method arguments:
  #   country_code        the country of the buyer [required]
  #   options             see below

  # Possible options are:
  #   :base_country_code    the country of the seller, if not given, then take the one by default [optional]
  #   :vat_number           in case the buyer left his vat number. Validation should have been done before [optional]
  #
  def self.get(country_code, options = {})
    raise NoCountryException if country_code.nil?

    country_code.upcase!

    if options[:base_country_code] && options[:base_country_code] != self.base_country # different country code for the seller ?
      if rule_data = VAT_RATES[options[:base_country_code]]
        rule = self.formalize_rate_rule(rule_data)
      end
    else
      rule = self.current_rate_rule
    end

    raise NoRuleFoundException if rule.nil?

    # same country for both the buyer and the seller, no need to go further
    return rule.rate if options[:base_country_code] == country_code

    if self.is_an_european_country?(country_code)
      if options[:vat_number].present? # case when the country of the buyer is in Europe, check if he has a vat_number
        rule.no_rate
      else
        rule.rate
      end
    elsif rate = rule.exceptions[country_code] # exceptions (France for instance has many exceptions for the DOM-TOM territories)
      rate
    else
      rule.no_rate
    end
  end

  def self.is_an_european_country?(country_code)
    EUROPEAN_COUNTRIES.include?(country_code.upcase)
  end

end

if defined?(Rails)
  if Rails::VERSION::MAJOR >= 3
    require 'vat_calculator/railtie'
  else
    puts "[Warning] VatCalculator does not work with Rails < 3"
  end
else
  VatCalculator.base_country ||= VatCalculator::DEFAULT_BASE_COUNTRY

  if rule_data = VatCalculator::VAT_RATES[VatCalculator.base_country]
    VatCalculator.current_rate_rule = VatCalculator.formalize_rate_rule(rule_data)
  end
end