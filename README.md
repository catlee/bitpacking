# Bitpacker

Bitpacker is a Ruby gem which wraps the Rust [bitpacking](https://github.com/quickwit-oss/bitpacking) crate.
It allows for efficient packing of arrays of integers.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bitpacker

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bitpacker

## Usage

```ruby
require "bitpacker"

data = [...] # Must be BitPacker::BitPacker4x::BLOCK_LEN in length
packer = BitPacker::BitPacker4x.new
num_bits = packer.num_bits(data)
compressed = packer.compress(data, num_bits)

original, num_bytes_unpacked = packer.decompress(compressed, num_bits)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/catlee/bitpacker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/catlee/bitpacker/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitpacker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bitpacker/blob/main/CODE_OF_CONDUCT.md).
