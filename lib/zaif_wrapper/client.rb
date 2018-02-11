# require 'bundler/setup'
require 'rest-client'
require 'json'
require 'byebug'

module ZaifWrapper
  module Client
    class ZaifPublicApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/api/1/'

      def request(path)
        response = RestClient.get "#{REQUEST_URL_BASE}#{path}"
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

    class ZaifPrivateApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/tapi'

      def initialize(api_key, api_secret)
        @api_key = api_key
        @api_secret = api_secret
      end

      def request(method)
        body = {
          'method' => method,
          'nonce' => get_nonce
        }
        signature_text = "method=#{method}&nonce=#{get_nonce}"
        response = RestClient.post REQUEST_URL_BASE, body, {content_type: :json, accept: :json, key: @api_key, sign: create_signature(signature_text)}
        JSON.parse(response.body)
      end

      def get_info
        request('get_info')
      end

      def get_nonce
        Time.now.to_f.to_i
      end

      def create_signature(body)
        OpenSSL::HMAC::hexdigest(OpenSSL::Digest.new('sha512'), @api_secret, body.to_s)
      end
    end
  end
end
