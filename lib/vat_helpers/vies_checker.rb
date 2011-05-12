require 'rubygems'
require 'soap/wsdlDriver'

module VatHelpers
  class ViesChecker

    WSDL = 'http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl'

    class << self
     def check(country_code, vat_number)
       begin
         proxy = SOAP::WSDLDriverFactory.new(WSDL).create_rpc_driver
         return proxy.checkVat(:countryCode => country_code, :vatNumber => vat_number).valid
       rescue
        false
       end
     end
    end
  end
end