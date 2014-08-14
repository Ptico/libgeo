# Libgeo

Collection of geographical primitives

- [![Build Status](https://travis-ci.org/Ptico/libgeo.png?branch=master)](https://travis-ci.org/Ptico/libgeo)
- [![Code Climate](https://codeclimate.com/github/Ptico/libgeo.png)](https://codeclimate.com/github/Ptico/libgeo)

## Installation

Add this line to your application's Gemfile:

    gem 'libgeo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libgeo

## Usage

### Latitude/Longitude

```ruby
lng = Longitude.decimal(39.342679)

lng.hemisphere # => :E
lng.degrees    # => 39
lng.minutes    # => 20
lng.seconds    # => 33.6444

lng.western?   # => false
lng.eastern?   # => true

lng.to_s    # => '39°20′33.6444″E'
lng.to_nmea # => '03920.56074,E'

lng.western!
lng.hemisphere # => :W

ltt = Latitude.nmea('03920.56074,N')

ltt.to_s  # => '39°20′33.6444″N'

ltt_dms = Latitude.dms('39°20′33.6444″N')

ltt_dms.to_s     # => '39°20′33.6444″N'
ltt_dms.to_nmea  # => '3920.56074,N'

```

## Contributing

1. Fork it ( http://github.com/Ptico/libgeo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
