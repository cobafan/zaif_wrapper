# require 'bundler/setup'
require 'faraday'
require 'json'

module ZaifWrapper
  module Client
    class ZaifPublicApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/api/1/'

      def request(path, params = {}, method = 'get')
        conn = Faraday.new(:url => REQUEST_URL_BASE)
        if method != 'post'
          response = conn.get do |req|
            req.url path
          end
        end
        JSON.parse(response.body)
      end

      ## currencies/#{currency_code}
      def currencies(currency_code)
        path = "currencies/#{currency_code}"
        request(path)
      end

      ## currency_pairs/#{currency_pair}
      def currency_pairs(currency_pair)
        path = "currency_pairs/#{currency_pair}"
        request(path)
      end

      ## /last_price/#{currency_pair}
      def last_price(currency_pair)
        path = "last_price/#{currency_pair}"
        request(path)
      end

      ## /ticker/#{currency_pair}
      def ticker(currency_pair)
        path = "ticker/#{currency_pair}"
        request(path)
      end

      ## /trades/#{currency_pair}
      def trades(currency_pair)
        path = "trades/#{currency_pair}"
        request(path)
      end

      ## /depth/#{currency_pair}
      def depth(currency_pair)
        path = "depth/#{currency_pair}"
        request(path)
      end
    end
  end
end
