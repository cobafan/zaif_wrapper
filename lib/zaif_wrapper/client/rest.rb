# require 'bundler/setup'
require 'faraday'
require 'json'

module Zaif_wrapper
  module Client
    class ZaifPublicApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/api/1/'

      def request(path, params = {}, method = 'get')
        conn = Faraday.new(:url => REQUEST_URL_BASE)
        if method != 'post'
          response = conn.get do |req|
            req.url path
          end
          # req.params['limit'] = 100
        end
        JSON.parse(response.body)
      end
      ## currencies/#{currency_code}
      def currencies(currency_code)
        path = "currencies/#{currency_code}"
        request(path)
      end
    end
  end
end
