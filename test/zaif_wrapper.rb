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
    @client = ZaifWrapper::Client::ZaifPublicApi.new()
  end

  def test_currencies_btc
    response = @client.currencies('btc')
    assert_equal 'btc', response[0]['name']
  end

  def test_currency_pairs_btc
    response = @client.currency_pairs('btc_jpy')
    assert_equal 'btc_jpy', response[0]['currency_pair']
  end
end
