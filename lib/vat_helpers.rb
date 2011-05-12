require 'ostruct'
require 'active_support'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_model'
require 'vat_helpers/vies_checker'
require 'vat_helpers/validator'
require 'vat_helpers/rate'

module VatHelpers

  mattr_accessor :base_country

  mattr_accessor :current_rate_rule

  # Constants ------------------------------------------------------------------

  DEFAULT_BASE_COUNTRY  = 'FR'

  VAT_PATTERNS = {
    'DE' => /\ADE[0-9]{9}\Z/,                                # Germany
    'AT' => /\AATU[0-9]{8}\Z/,                               # Austria
    'BE' => /\ABE[0-9]{10}\Z/,                               # Belgium
    'BG' => /\ABG[0-9]{9,10}\Z/,                             # Bulgaria
    'CY' => /\ACY[0-9]{8}[A-Z]\Z/,                           # Cyprus
    'DK' => /\ADK[0-9]{8}\Z/,                                # Denmark
    'ES' => /\AES[0-9]{9}\Z/,                                # Spain
    'EE' => /\AEE[0-9]{9}\Z/,                                # Estonia
    'FI' => /\AFI[0-9]{8}\Z/,                                # Finland
    'FR' => /\AFR[A-Z0-9]{2}[0-9]{9}\Z/,                     # France
    'EL' => /\AEL[0-9]{9}\Z/,                                # Greece
    'HU' => /\AHU[0-9]{8}\Z/,                                # Hungary
    'IE' => /\AIE([0-9][A-Z][0-9]{5}[A-Z]|[0-9]{7}[A-Z])\Z/, # Ireland
    'IT' => /\AIT[0-9]{11}\Z/,                               # Italy
    'LV' => /\ALV[0-9]{11}\Z/,                               # Latvia
    'LT' => /\ALT([0-9]{9}|[0-9]{12})\Z/,                    # Lithuania
    'LU' => /\ALU[0-9]{8}\Z/,                                # Luxembourg
    'MT' => /\AMT[0-9]{8}\Z/,                                # Malta
    'NL' => /\ANL[0-9]{9}[A-Z][0-9]{2}\Z/,                   # Netherlands
    'PL' => /\APL[0-9]{10}\Z/,                               # Poland
    'PT' => /\APT[0-9]{9}\Z/,                                # Portugal
    'GB' => /\AGB([0-9]{9}|[A-Z0-9]{2}[0-9]{3})\Z/,          # United Kingdom
    'RO' => /\ARO[0-9]{9}\Z/,                                # Romania
    'SK' => /\ASK[0-9]{10}\Z/,                               # Slovakia
    'SI' => /\ASI[0-9]{8}\Z/,                                # Slovenia
    'SE' => /\ASE[0-9]{12}\Z/,                               # Sweden
    'CZ' => /\ACZ[0-9]{8,10}\Z/                              # Czech Republic
  }

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

end

if defined?(Rails)
  if Rails::VERSION::MAJOR >= 3
    require 'vat_helpers/railtie'
  else
    puts "[Warning] VatHelpers does not work with Rails < 3"
  end
else
  ActiveModel::Validations.__send__(:include, VatHelpers::Validators)
  VatHelpers.base_country ||= VatHelpers::DEFAULT_BASE_COUNTRY

  if rule_data = VatHelpers::VAT_RATES[VatHelpers.base_country]
    VatHelpers.current_rate_rule = VatHelpers.formalize_rate_rule(rule_data)
  end
end