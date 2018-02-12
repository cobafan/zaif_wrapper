# require 'bundler/setup'
require 'rest-client'
require 'json'
require 'byebug'
require 'websocket-client-simple'

module ZaifWrapper
  module Client
    class ZaifParentApi
      PUBLIC_REQUEST_URL_BASE  = 'https://api.zaif.jp/api/1/'
      PRIVATE_REQUEST_URL_BASE = 'https://api.zaif.jp/tapi'

      def get_request(path)
        response = RestClient.get "#{PUBLIC_REQUEST_URL_BASE}#{path}"
        JSON.parse(response.body)
      end

      def get_nonce
        Time.now.to_f.to_i
      end

      def create_signature(body)
        OpenSSL::HMAC::hexdigest(OpenSSL::Digest.new('sha512'), @api_secret, body.to_s)
      end

    end
    class ZaifPublicApi < ZaifParentApi
      METHODS = {
                  :currencies     => 'currency_code',
                  :currency_pairs => 'currency_pair',
                  :last_price     => 'currency_pair',
                  :ticker         => 'currency_pair',
                  :trades         => 'currency_pair',
                  :depth          => 'currency_pair'
                }.freeze

      METHODS.each do |method_name, params|
        define_method(method_name) { |params|
          path = "#{method_name.to_s}/#{params}"
          get_request(path)
        }
      end
    end

    class ZaifPrivateApi < ZaifParentApi
      METHODS = ['get_info', 'get_info2', 'get_personal_info', 'get_id_info', 'trade_history', 'active_orders', 'trade', 'cancel_order', 'withdraw', 'deposit_history', 'withdraw_history'].freeze

      def initialize(api_key, api_secret)
        @api_key = api_key
        @api_secret = api_secret
      end

      def method_missing(name, *args)
        if METHODS.include?(name.to_s)
          klass = class << self; self end
          klass.class_eval do
            define_method(name) do |body = {}|
              check(name, body)
              body.store("method", name.to_s)
              post_request(body)
            end
          end
          if args.length == 1
            __send__(name, args[0])
          else
            __send__(name)
          end
        end
      end

      def post_request(body)
        body.store('nonce', get_nonce)
        signature_text = ""
        body.each_with_index { |param, i|
          signature_text = signature_text + '&' if i != 0
          signature_text = "#{signature_text}#{param[0]}=#{param[1]}"
        }
        response = RestClient.post PRIVATE_REQUEST_URL_BASE, body, {
            content_type: :json,
            accept: :json,
            key: @api_key,
            sign: create_signature(signature_text)
        }
        JSON.parse(response.body)
      end

      def check(method_name, body)
        case method_name
          when 'trade' then
            raise "Required parameters are missing" if body["currency_pair"].nil? || body["action"].nil? || body["price"].nil? || body["amount"].nil?
          when 'cancel_order' then
            raise "Required parameters are missing" if body["order_id"].nil?
          when 'withdraw' then
            raise "Required parameters are missing" if body["currency"].nil? || body["address"].nil? || body["amount"].nil?
          when 'deposit_history' then
            raise "Required parameters are missing" if body["currency"].nil?
          when 'withdraw_history' then
            raise "Required parameters are missing" if body["currency"].nil?
        end
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
    end

    class ZaifStreamApi
      REQUEST_URL_BASE = 'wss://ws.zaif.jp:'

      def initialize(port = 8888)
        @port = port
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
