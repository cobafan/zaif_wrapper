# coding: utf-8
# frozen_string_literal: true
require 'bundler/setup'

require 'minitest/autorun'
require 'zaif_wrapper'
require 'coveralls'
require 'dotenv'

Dotenv.load

require 'json_expressions/minitest'
Coveralls.wear!

class ZaifPrivateApi < MiniTest::Test
  def setup
    @client = ZaifWrapper::Client::ZaifPrivateApi.new(ENV['ZAIF_API_KEY'], ENV['ZAIF_API_SECRET'])
  end

  def test_get_info
    response = @client.get_info
    assert_equal 1, response['success']
  end

  def test_get_info2
    response = @client.get_info2
    assert_equal 1, response['success']
  end

  def test_get_personal_info
    response = @client.get_personal_info
    assert_equal 1, response['success']
  end

  def test_get_id_info
    response = @client.get_id_info
    assert_equal 1, response['success']
  end

  def test_trade_history
    response = @client.trade_history
    assert_equal 1, response['success']
  end

  def test_active_orders
    response = @client.active_orders
    assert_equal 1, response['success']
  end

  def test_trade
    response = @client.trade({
                                 currency_pair: 'btc_jpy',
                                 action: 'bid',
                                 price: 2000000,
                                 amount: 0.0001
                                       })
    assert_equal 1, response['success']
  end

  def test_cancel_order
    @client.trade({
                   currency_pair: 'btc_jpy',
                   action: 'bid',
                   price: 2000000,
                   amount: 0.0001
                 })
    response = @client.active_orders
    response2 = @client.cancel_order({
                                         order_id: response['return'][0]
                                     })
    assert_equal 1, response2['success']
  end

  def test_withdraw
    response = @client.withdraw({
                                           currency: 'xem',
                                           address: ENV['XEM_WITHDRAW_ADDRESS'],
                                           amount: 0.1
                                       })
    assert_equal 1, response['success']
  end

  def test_deposit_history
    response = @client.deposit_history({
                                           currency: 'jpy'
                                       })
    assert_equal 1, response['success']
  end

  def test_withdraw_history
    response = @client.withdraw_history({
                                           currency: 'jpy'
                                       })
    assert_equal 1, response['success']
  end
end
