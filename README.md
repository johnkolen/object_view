# ObjectView
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "object_view"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install object_view
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Useful stuff

Add a helper test
```bash
rails generate rspec:helper elements
```

To make a model
```bash
cd rspec/dummy
rails generate model Person name:string
```

Build the gem
```bash
gem build object_view.gemspec
```

Add a generator
```bash
rails generate generator views
```
