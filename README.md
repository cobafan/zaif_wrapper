# ZaifWrapper

This is an unofficial Ruby wrapper for the Zaif exchange REST APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zaif_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zaif_wrapper

#### REST Client

Require zaif_wrapper:

```ruby
require 'zaif_wrapper'
```

#### [Public Client](http://techbureau-api-document.readthedocs.io/ja/latest/public/index.html)
```ruby
# If you only plan on touching public API endpoints.
client = ZaifWrapper::Client::ZaifPublicApi.new
```

Create various requests:

```ruby
client.currencies('btc') # => [{ "name": "btc", "is_token": false }]
client.currency_pairs('btc_jpy')
client.last_price('btc_jpy')
client.ticker('btc_jpy')
client.trades('btc_jpy')
client.depth('btc_jpy')
```

#### [Private Client](http://techbureau-api-document.readthedocs.io/ja/latest/trade/index.html)
```ruby
# If you only plan on touching Future API endpoints.
client = ZaifWrapper::Client::ZaifPrivateApi.new(api_key, api_secret)
```

```ruby
client.get_info
client.get_info2
client.get_personal_info
client.get_id_info
client.trade_history
client.active_orders
client.trade({
  currency_pair: 'btc_jpy',
  action: 'bid',
  price: 1000000,
  amount: 0.0001
})
client.cancel_order({
  order_id: 1
})
client.withdraw({
  currency: 'btc',
  address: 'abcabcabcabc',
  amount: 0.3  
})
client.deposit_history({
  currency: 'jpy'
})
client.withdraw_history({
  currency: 'jpy'
})
```

#### [Future Client](http://techbureau-api-document.readthedocs.io/ja/latest/public_futures/index.html)
```ruby
# If you only plan on touching Future API endpoints.
client = ZaifWrapper::Client::ZaifFutureApi.new
```

#### [Leverage Client](http://techbureau-api-document.readthedocs.io/ja/latest/trade_leverage/index.html)
```ruby
# If you only plan on touching Leverage API endpoints.
client = ZaifWrapper::Client::ZaifLeverageApi.new
```

#### [WebSocket Client](http://techbureau-api-document.readthedocs.io/ja/latest/public/3_streaming.html)
```ruby
# If you only plan on connecting WebSocket API endpoints.
client = ZaifWrapper::Client::ZaifStreamApi.new
client.stream('btc_jpy')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cobafan/zaifWrapper. 
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Donate

If This library is useful to you feel free to donate zaif with twitter chip.
* screen_name: cobafan
* donate_me: https://zaif.jp/social/tw/sendtip
