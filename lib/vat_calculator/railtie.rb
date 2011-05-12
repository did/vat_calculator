module VatCalculator

  class Railtie < Rails::Railtie

    config.vat_calculator_base_country = DEFAULT_BASE_COUNTRY

    initializer 'vat_calculator.initialize' do |app|
      VatCalculator.base_country = app.config.vat_calculator_base_country.upcase

      if rule = VatCalculator::VAT_RATES[VatCalculator.base_country]
        VatCalculator.current_rate_rule = VatCalculator.formalize_rate_rule(rule)
      end
    end
  end

end