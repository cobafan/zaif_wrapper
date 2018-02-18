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

class ZaifLeverageApi < MiniTest::Test
  def setup
    @client = ZaifWrapper::Client::ZaifLeverageApi.new(ENV['ZAIF_API_KEY'], ENV['ZAIF_API_SECRET'])
  end

  def test_get_positions
    response = @client.get_positions({
        type: 'margin'
                                })
    assert_equal 1, response['success']
  end

  def test_position_history
    response = @client.position_history({
                                         type: 'margin'
                                     })
    assert_equal 1, response['success']
  end

  def test_active_positions
    response = @client.active_positions({
                                            type: 'margin'
                                        })
    assert_equal 1, response['success']
  end

  def test_create_position
    response = @client.create_position({
                                            type: 'margin',
                                            currency_pair: 'btc_jpy',
                                            action: 'bid',
                                            price: 1165900,
                                            amount:  0.0001,
                                            leverage: 1
                                        })
    assert_equal 1, response['success']
  end

  def test_change_position
    response = @client.active_positions({
                                            type: 'margin'
                                        })
    response2 = @client.change_position({
                                           type: 'margin',
                                           leverage_id: response[0],
                                           price: 1165900,
                                       })
    assert_equal 1, response2['success']
  end

  def test_cancel_position
    response = @client.active_positions({
                                            type: 'margin'
                                        })
    response2 = @client.cancel_position({
                                            type: 'margin',
                                            leverage_id: response[0],
                                        })
    assert_equal 1, response2['success']
  end
end
