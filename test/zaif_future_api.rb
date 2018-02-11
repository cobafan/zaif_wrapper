# coding: utf-8
# frozen_string_literal: true
require 'bundler/setup'

require 'minitest/autorun'
require 'zaif_wrapper'
require 'coveralls'
require 'byebug'

require 'json_expressions/minitest'
Coveralls.wear!

class ZaifFutureApi < MiniTest::Test
  def setup
    @client = ZaifWrapper::Client::ZaifFutureApi.new
  end

  def test_groups
    response = @client.groups(1)
    assert_equal 'btc_jpy', response[0]['currency_pair']
  end

  def test_last_price
    response = @client.last_price(1, 'btc_jpy')
    assert_kind_of Float,response['last_price']
  end

  def test_ticker
    response = @client.ticker(1, 'btc_jpy')
    assert_kind_of Float,response['bid']
  end

  def test_trades
    response = @client.trades(1, 'btc_jpy')
    assert_equal 'btc_jpy', response[0]['currency_pair']
  end

  def test_depth
    response = @client.depth(1, 'btc_jpy')
    assert_kind_of Float,response['asks'][0][0]
  end

end
