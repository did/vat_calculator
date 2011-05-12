module VatHelpers

  class Railtie < Rails::Railtie

    config.vta_applied_for = DEFAULT_BASE_COUNTRY

    initializer 'vat_helpers.initialize' do |app|
      ActiveModel::Validations.__send__(:include, VatHelpers::Validators)

      ::VatHelpers.base_country = app.config.vta_applied_for.upcase

      if rule = VatHelpers::VAT_RATES[VatHelpers.base_country]
        VatHelpers.current_rate_rule = VatHelpers.formalize_rate_rule(rule)
      end
    end
  end

end