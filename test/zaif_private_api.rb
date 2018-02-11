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

class ZaifPrivateApiTest < MiniTest::Test
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
  end

  def cancel_order
  end

  def withdraw
  end

  def deposit_history
  end

  def withdraw_history
  end
end
