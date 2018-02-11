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

Create a new instance of the REST Client Class:

```ruby
# If you only plan on touching public API endpoints.
client = Zaif_wrapper::Client::ZaifPublicApi.new
```

Create various requests:

```ruby
# Ping the server
client.currencies('btc') # => [{ "name": "btc", "is_token": false }]

```

#### WebSocket Client


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cobafan/zaif_wrapper. 
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Donate

If This library is useful to you feel free to donate zaif with twitter chip.
* screen_name: cobafan
