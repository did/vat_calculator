module VatHelpers

    module Validators

    class VatValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        format_valid = true

        if options[:country_method]
          country_code = record.send(options[:country_method]).to_s
          unless VAT_PATTERNS.has_key?(country_code) && value.to_s =~ VAT_PATTERNS[country_code]
            record.errors.add(attribute, options[:message])
            format_valid = false
          end
        else
          unless value =~ VAT_PATTERNS.values.detect { |p| value.to_s =~ p }
            record.errors.add(attribute, options[:message])
            format_valid = false
          end
        end

        if format_valid && options[:vies]
          unless ViesChecker.check(value.to_s[0..1], value.to_s[2..15])
            record.errors.add(attribute, options[:message])
          end
        end
      end
    end
  end

end
