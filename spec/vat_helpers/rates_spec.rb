require 'spec_helper'

describe 'Processing tax rate' do

  it 'should raise an exception of no country is provided' do
    lambda {
      VatHelpers::Rate.get(nil)
    }.should raise_exception(VatHelpers::Rate::NoCountryException)
  end

  it 'should raise an exception of the country of the seller is not recorded' do
    lambda {
      VatHelpers::Rate.get('FR', { :base_country_code => 'DE' })
    }.should raise_exception(VatHelpers::Rate::NoRuleFoundException)
  end

  context 'Seller in France' do

    it 'should apply tax since the customer is in France' do
      VatHelpers::Rate.get('FR').should == 19.6
    end

    it 'shoud apply tax if the buyer is in Europe BUT didn\'t give his vta number in CEE' do
      VatHelpers::Rate.get('IT').should == 19.6
    end

    it 'shoud not apply tax if the buyer is in Europe AND gave his vta number in CEE' do
      VatHelpers::Rate.get('IT', { :vat_number => 'valid_number' }).should == 0.0
    end

    %w(GP MQ RE).each do |code|
      it "shoud apply a different tax rate if the buyer is in the country with the '#{code}' code" do
        VatHelpers::Rate.get(code).should == 8.5
      end
    end

    it 'shoud not apply tax if the buyer lives in French Guyana' do
      VatHelpers::Rate.get('GF').should == 0.0
    end

    it 'should not apply tax if the buyer lives is in the United States' do
      VatHelpers::Rate.get('US').should == 0.0
    end

  end

end