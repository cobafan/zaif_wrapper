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

  def get_positions
  end

  def position_history
  end

  def active_positions
  end

  def create_position
  end

  def change_position
  end

  def cancel_position
  end
end
