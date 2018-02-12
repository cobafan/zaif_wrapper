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
      LEVERAGE_REQUEST_URL_BASE = 'https://api.zaif.jp/tlapi'

      def get_request(host, path)
        response = RestClient.get "#{host}#{path}"
        JSON.parse(response.body)
      end

      def post_request(body, host)
        body.store('nonce', get_nonce)
        signature_text = ""
        body.each_with_index { |param, i|
          signature_text = signature_text + '&' if i != 0
          signature_text = "#{signature_text}#{param[0]}=#{param[1]}"
        }
        response = RestClient.post host, body, {
            content_type: :json,
            accept: :json,
            key: @api_key,
            sign: create_signature(signature_text)
        }
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
          get_request(PUBLIC_REQUEST_URL_BASE, path)
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
              post_request(body, PRIVATE_REQUEST_URL_BASE)
            end
          end
          if args.length == 1
            __send__(name, args[0])
          else
            __send__(name)
          end
        end
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

    class ZaifLeverageApi < ZaifParentApi
      METHODS = ['get_positions', 'position_history', 'active_positions', 'create_position', 'change_position', 'cancel_position'].freeze

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
              post_request(body, LEVERAGE_REQUEST_URL_BASE)
            end
          end
          if args.length == 1
            __send__(name, args[0])
          else
            __send__(name)
          end
        end
      end


      def check(method_name, body)
        case method_name
          when 'get_positions' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?)
          when 'position_history' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?)
          when 'active_positions' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?)
          when 'create_position' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?) || body["currency_pair"].nil? || body["action"].nil? || body["price"].nil? || body["amount"].nil? || body["leverage"].nil?
          when 'change_position' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?) || body["leverage_id"].nil? || body["price"].nil?
          when 'cancel_position' then
            raise "Required parameters are missing" if body["type"].nil? || (body["type"] == 'futures' && body["group_id"].nil?) || body["leverage_id"].nil?
        end
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
