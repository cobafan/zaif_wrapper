#coding: utf-8
# frozen_string_literal: true
require 'bundler/setup'

require 'minitest/autorun'
require 'zaif_wrapper'
require 'coveralls'
require 'byebug'

require 'json_expressions/minitest'
Coveralls.wear!

class ZaifWrapperTest < MiniTest::Test
  def setup
    @public_client = ZaifWrapper::Client::ZaifPublicApi.new
  end

  def test_currencies_btc
    response = @public_client.currencies('btc')
    assert_equal 'btc', response[0]['name']
  end

  def test_currency_pairs_btc_jpy
    response = @public_client.currency_pairs('btc_jpy')
    assert_equal 'btc_jpy', response[0]['currency_pair']
  end

  def test_last_price_btc_jpy
    response = @public_client.last_price('btc_jpy')
    assert_kind_of Float,response['last_price']
  end

  def test_ticker_btc_jpy
    response = @public_client.ticker('btc_jpy')
    assert_kind_of Float,response['last']
    assert_kind_of Float,response['ask']
  end

  def test_trades_btc_jpy
    response = @public_client.trades('btc_jpy')
    assert_kind_of Float,response[0]['price']
    assert_equal 'btc_jpy', response[0]['currency_pair']
  end

  def test_depth_btc_jpy
    response = @public_client.depth('btc_jpy')
    assert_kind_of Float,response['asks'][0][0]
  end

end
