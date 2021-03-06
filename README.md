# OmniAuth Dnevnik

Unofficial OmniAuth strategy for [Dnevnik SSO OAuth2](http://api.dnevnik.ru/#Авторизация) integration.

## Installation

Add the gem to your application's Gemfile:

    gem 'omniauth-dnevnik', '~> 1.0.3', :git => 'git://github.com/schory/omniauth-dnevnik.git'

And then execute:

    $ bundle

## Usage

OmniAuth Dnevnik is Rack Middleware in the OmniAuth convention. See the
[OmniAuth 1.0 docs](https://github.com/intridea/omniauth) for more information.

Follow the Cnevnik OAuth docs to register your application, set callback URLs,
and get a client ID and client secret.

Example: In `config/initializers/omniauth.rb`, do:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dnevnik, ENV['DNEVNIK_KEY'], ENV['DNEVNIK_SECRET']
end
```

## Configuring

To be able to set the optional `dnevnik_landing` or `dev` parameters on a
per-request basis by passing these params to your `/auth/dnevnik` url, use
this in the initializer instead:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dnevnik, ENV['DNEVNIK_KEY'], ENV['DNEVNIK_SECRET'],
           :setup => lambda { |env|
             params = Rack::Utils.parse_query(env['QUERY_STRING'])
             env['omniauth.strategy'].options[:client_options][:dnevnik_landing] = params['dnevnik_landing']
             env['omniauth.strategy'].options[:client_options][:dev] = params['dev']
           }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT. See LICENSE.txt.

## Thank yous

Thank you to [Omniauth](https://github.com/intridea/omniauth)
for making it so easy create this gem!
