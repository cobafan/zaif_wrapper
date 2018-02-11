# require 'bundler/setup'
require 'rest-client'
require 'json'
require 'byebug'
require 'websocket-client-simple'

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

      def request(method, params = {})
        body = {
          'method' => method,
          'nonce' => get_nonce
        }
        signature_text = "method=#{method}&nonce=#{get_nonce}"
        unless params.empty?
          params.each { |param|
            body.store(param[0], param[1])
            signature_text = "#{signature_text}&#{param[0]}=#{param[1]}"
          }
        end

        response = RestClient.post REQUEST_URL_BASE, body, {
            content_type: :json,
            accept: :json,
            key: @api_key,
            sign: create_signature(signature_text)
        }
        JSON.parse(response.body)
      end

      def get_info
        request('get_info')
      end

      def get_info2
        request('get_info2')
      end

      def get_personal_info
        request('get_personal_info')
      end

      def get_id_info
        request('get_id_info')
      end

      def trade_history(params = {})
        request('trade_history', params)
      end

      def active_orders(params = {})
        request('active_orders', params)
      end

      def trade(params = {})
        raise "Required parameters are missing" if params["currency_pair"].nil? || params["action"].nil? || params["price"].nil? || params["amount"].nil?
        request('trade', params)
      end

      def cancel_order(params = {})
        raise "Required parameters are missing" if params["order_id"].nil?
        request('cancel_order', params)
      end

      def withdraw(params = {})
        raise "Required parameters are missing" if params["currency"].nil? || params["address"].nil? || params["amount"].nil?
        request('withdraw', params)
      end

      def deposit_history(params = {})
        raise "Required parameters are missing" if params["currency"].nil?
        request('deposit_history', params)
      end

      def withdraw_history(params = {})
        raise "Required parameters are missing" if params["currency"].nil?
        request('withdraw_history', params)
      end

      def get_nonce
        Time.now.to_f.to_i
      end

      def create_signature(body)
        OpenSSL::HMAC::hexdigest(OpenSSL::Digest.new('sha512'), @api_secret, body.to_s)
      end
    end

    class ZaifFutureApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/fapi/1/'

      def request(path)
        response = RestClient.get "#{REQUEST_URL_BASE}#{path}"
        JSON.parse(response.body)
      end

      ## /groups/#{group_id}
      def groups(group_id)
        path = "groups/#{group_id}"
        request(path)
      end

      ## last_price/#{group_id}#{currency_pair}
      def last_price(group_id, currency_pair)
        path = "last_price/#{group_id}/#{currency_pair}"
        request(path)
      end

      ## /ticker/#{group_id}/#{currency_pair}
      def ticker(group_id, currency_pair)
        path = "ticker/#{group_id}/#{currency_pair}"
        request(path)
      end

      ## /trades/{group_id}/{currency_pair}
      def trades(group_id, currency_pair)
        path = "trades/#{group_id}/#{currency_pair}"
        request(path)
      end

      ## /depth/{group_id}/{currency_pair}
      def depth(group_id, currency_pair)
        path = "depth/#{group_id}/#{currency_pair}"
        request(path)
      end
    end

    class ZaifLeverageApi
      REQUEST_URL_BASE = 'https://api.zaif.jp/tlapi'

      def initialize(api_key, api_secret)
        @api_key = api_key
        @api_secret = api_secret
      end

      def request(method, params = {})
        body = {
            'method' => method,
            'nonce' => get_nonce
        }
        signature_text = "method=#{method}&nonce=#{get_nonce}"
        unless params.empty?
          params.each { |param|
            body.store(param[0], param[1])
            signature_text = "#{signature_text}&#{param[0]}=#{param[1]}"
          }
        end

        response = RestClient.post REQUEST_URL_BASE, body, {
            content_type: :json,
            accept: :json,
            key: @api_key,
            sign: create_signature(signature_text)
        }
        JSON.parse(response.body)
      end

      def get_positions(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?)
        request('get_positions', params)
      end

      def position_history(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?)
        request('position_history', params)
      end

      def active_positions(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?)
        request('active_positions', params)
      end

      def create_position(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?) || params["currency_pair"].nil? || params["action"].nil? || params["price"].nil? || params["amount"].nil? || params["leverage"].nil?
        request('create_position', params)
      end

      def change_position(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?) || params["leverage_id"].nil? || params["price"].nil?
        request('change_position', params)
      end

      def cancel_position(params = {})
        raise "Required parameters are missing" if params["type"].nil? || (params["type"] == 'futures' && params["group_id"].nil?) || params["leverage_id"].nil?
        request('cancel_position', params)
      end

      def get_nonce
        Time.now.to_f.to_i
      end

      def create_signature(body)
        OpenSSL::HMAC::hexdigest(OpenSSL::Digest.new('sha512'), @api_secret, body.to_s)
      end
    end
    class ZaifStreamApi
      REQUEST_URL_BASE = 'wss://ws.zaif.jp:'

      def initialize(port = 8888)
        @port = port
      end
      def request(path)
        response = RestClient.get "#{REQUEST_URL_BASE}#{path}"
        JSON.parse(response.body)
      end

      ## wss://ws.zaif.jp/stream?currency_pair={currency_pair}
      def stream(currency_pair, output_filename = nil)
        f = if output_filename.nil?
              STDOUT
            else
              File.open(output_filename, 'a')
            end

        ws = WebSocket::Client::Simple.connect "#{REQUEST_URL_BASE}#{@port}/stream?currency_pair=#{currency_pair}"
        ws.on :message do |msg|
          f.puts msg.data + "\n"
        end

        ws.on :close do |e|
          f.close unless output_filename.nil?
        end

        loop do
        end
      end
    end
  end
end
