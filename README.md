# Description

Use this plugin to calculate the VAT rate depending on the country of the buyer.

# Configuration

First set the country of the seller in your config/application.rb file

    config.vat_calculator_base_country = 'FR' # or 'BE', etc....

Note: by default, the value of the vat_calculator_base_country option is set to 'FR'

# Basic usage

Let's review the different cases for a seller in France:

1. the buyer is outside Europe

        VatCalculator.get('US') # returns 0.0

2. the buyer is in France

        VatCalculator.get('FR') # returns 19.6

3. the buyer is in Europe without a vat number

        VatCalculator.get('BE') # returns 19.6

4. the buyer is in Europe with an almost correct vat number

        VatCalculator.get('BE', { vat_number: 'a_valid_vat_number' }) # returns 0.0

5. the buyer is in Europe with an almost correct vat number

        VatCalculator.get('BE', { vat_number: 'bla bla', validation: :simple }) # returns 19.6

6. the buyer is in Europe with an almost correct vat number

        VatCalculator.get('BE', { vat_number: 'BE00000000000', validation: :full }) # returns 0.0

7. the buyer is in Martinique, Guadeloupe or la Réunion

        VatCalculator.get('MQ') # returns 8.5

8. the buyer is in French Guyana

        VatCalculator.get('GF') # returns 0.0

# Installation

In your project's Gemfile :

    gem 'vat_calculator', git: 'git://github.com/did/vat_calculator.git'

# Tests

If you want to run the specs :

    bundle exec rake spec

# Credits

This plugin in released under MIT license by Didier Lafforgue (see MIT-LICENSE
file).

(c) http://www.nocoffee.fr