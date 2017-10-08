# gpio.cr

GPIO access using sysfs interface in Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gpio:
    github: petoem/gpio.cr
```

## Usage

```crystal
require "gpio"

GPIO.pin_mode 0, GPIO::INPUT
puts GPIO.read_pin 0
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/petoem/gpio.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [petoem](https://github.com/petoem) Michael Petö - creator, maintainer
