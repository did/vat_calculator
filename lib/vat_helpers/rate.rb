module VatHelpers

  module Rate

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

      if options[:base_country_code] && options[:base_country_code] != VatHelpers.base_country # different country code for the seller ?
        if rule_data = VatHelpers::VAT_RATES[options[:base_country_code]]
          rule = VatHelpers.formalize_rate_rule(rule_data)
        end
      else
        rule = VatHelpers.current_rate_rule
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
      VAT_PATTERNS.keys.include?(country_code.upcase)
    end


  end

end