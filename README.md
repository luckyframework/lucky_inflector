# Wordsmith

This project is still new. Guides will be posted when things are more complete.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  wordsmith:
    github: crystal-loot/wordsmith
```

## Usage

```crystal
require "wordsmith"

Wordsmith::Inflector.pluralize("word") # "words"
Wordsmith::Inflector.singularize("categories") # "category"
```

## Contributing

1. Fork it ( https://github.com/crystal-loot/wordsmith/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Testing

To run the tests:
* Run the tests with `crystal spec`

## Contributors

- [paulcsmith](https://github.com/paulcsmith) Paul Smith - creator, maintainer
- [actsasflinn](https://github.com/actsasflinn) Flinn Mueller - contributor

## Thanks & attributions

* Inflector is based on [Rails](https://github.com/rails/rails). Thank you to the Rails team!
