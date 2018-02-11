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

#### Public Client
```ruby
# If you only plan on touching public API endpoints.
client = Zaif_wrapper::Client::ZaifPublicApi.new
```

Create various requests:

```ruby
client.currencies('btc') # => [{ "name": "btc", "is_token": false }]
client.currency_pairs('btc_jpy')
client.last_price('btc_jpy')
client.depth('btc_jpy')
```

#### Private Client
```ruby
# If you only plan on touching Future API endpoints.
client = Zaif_wrapper::Client::ZaifPrivateApi.new(api_key, api_secret)
```

```ruby
client.currencies('btc') # => [{ "name": "btc", "is_token": false }]
client.currency_pairs('btc_jpy')
client.last_price('btc_jpy')
client.depth('btc_jpy')
```

#### Future Client(No Test)
```ruby
# If you only plan on touching Future API endpoints.
client = Zaif_wrapper::Client::ZaifFutureApi.new
```

#### Future Client(No Test)
```ruby
# If you only plan on touching Future API endpoints.
client = Zaif_wrapper::Client::ZaifFutureApi.new
```

#### Leverage Client(No Test)
```ruby
# If you only plan on touching Leverage API endpoints.
client = Zaif_wrapper::Client::ZaifLeverageApi.new
```

#### WebSocket Client(No Test)
```ruby
# If you only plan on connecting WebSocket API endpoints.
client = Zaif_wrapper::Client::ZaifStreamApi.new
client.stream('btc_jpy')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cobafan/zaif_wrapper. 
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Donate

If This library is useful to you feel free to donate zaif with twitter chip.
* screen_name: cobafan
