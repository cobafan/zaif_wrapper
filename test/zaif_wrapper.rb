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
    @zaif_wrapper = Zaif_wrapper::Client::ZaifPublicApi.new()
  end

  def test_currencies_btc
    response = @zaif_wrapper.currencies('btc')
    assert_equal 'btc', response[0]['name']
  end

end
