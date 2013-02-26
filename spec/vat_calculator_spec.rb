require 'spec_helper'

describe 'Processing tax rate' do

  it 'should raise an exception of no country is provided' do
    lambda {
      VatCalculator.get(nil)
    }.should raise_exception(VatCalculator::NoCountryException)
  end

  it 'should raise an exception of the country of the seller is not recorded' do
    lambda {
      VatCalculator.get('FR', { base_country_code: 'DE' })
    }.should raise_exception(VatCalculator::NoRuleFoundException)
  end

  context 'Seller in France' do

    it 'should apply tax since the customer is in France' do
      VatCalculator.get('FR').should == 19.6
    end

    it 'should apply tax if the buyer is in Europe BUT didn\'t give his vta number in CEE' do
      VatCalculator.get('IT').should == 19.6
    end

    it 'should not apply tax if the buyer is in Europe AND gave his vta number in CEE' do
      VatCalculator.get('IT', { vat_number: 'valid_number' }).should == 0.0
    end

    # Note (Did): see the vat_calculator.rb file for more explanations
    # %w(GP MQ RE).each do |code|
    #   it "should apply a different tax rate if the buyer is in the country with the '#{code}' code" do
    #     VatCalculator.get(code).should == 8.5
    #   end
    # end

    it 'should not apply tax if the buyer lives in French Guyana' do
      VatCalculator.get('GF').should == 0.0
    end

    it 'should not apply tax if the buyer lives is in the United States' do
      VatCalculator.get('US').should == 0.0
    end

  end

  context 'Validating the VAT number' do

    it 'refuses a wrong VAT number' do
      VatCalculator.get('IT', { vat_number: 'invalid_number', validation: :simple }).should == 19.6
    end

    it 'accepts a wrong VAT number which looks like almost valid' do
      VatCalculator.get('IT', { vat_number: 'IT12345678923', validation: :simple }).should == 0.0
    end

    it 'refuses a VAT number by calling an external service' do
      VatCalculator.get('IT', { vat_number: 'IT12345678923', validation: :full }).should == 19.6
    end

    it 'accepts a VAT number by calling an external service' do
      VatCalculator.get('SE', { vat_number: 'SE556866920301', validation: :full }).should == 0.0
    end

  end

end