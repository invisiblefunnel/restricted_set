# RestrictedSet [![Build Status](https://travis-ci.org/invisiblefunnel/restricted_set.png?branch=master)](https://travis-ci.org/invisiblefunnel/restricted_set)

> RestricedSet implements a set with restrictions defined by a given block. If the block's arity is 2, it is called with the RestrictedSet itself and an object to see if the object is allowed to be put in the set. Otherwise, the block is called with an object to see if the object is allowed to be put in the set.

> Credit: [lib/set.rb][ruby-restricted-set]

This project is inspired by a data structure described in the Ruby codebase. The interface matches the described class and the implementation is complete, tested and avoids dynamically defining methods on each instance.

**Compatible with Ruby 1.9+**

The source is released under the same terms as [Ruby][ruby-license].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'restricted_set'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install restricted_set
```

## Usage

```ruby
set = RestrictedSet.new(-2..2) { |o| o > 0 }
set.add(-1)
set.add(42)
set #=> #<RestrictedSet: {1, 2, 42}>
```

```ruby
set = RestrictedSet.new { |o| Symbol === o }
set.add("Hello!")
set.add(:name)
set.add(99)
set.add(:location)
set #=> #<RestrictedSet: {:name, :location}>
```

```ruby
set = RestrictedSet.new do |current_set, _|
  current_set.count + 1 <= 2 # Maximum of 2 objects
end
set << :a << :b << :c
set #=> #<RestrictedSet: {:a, :b}>
```

```ruby
require 'prime'
class PrimeSet < RestrictedSet
  def initialize(enum = nil)
    super enum, &Prime.method(:prime?)
  end
end

(1..100).to_set(PrimeSet) #=> #<PrimeSet: {2, 3, 5, 7, 11, 13, 17, 19, ...}>
```

```ruby
class NullSet < RestrictedSet
  def initialize(enum = nil)
    super(enum) { false }
  end
end

set = NullSet.new
set << 1 << 'a' << :b
set #=> #<NullSet: {}>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[ruby-restricted-set]: https://github.com/ruby/ruby/blob/v2_0_0_247/lib/set.rb#L640-L665
[ruby-license]: https://www.ruby-lang.org/en/about/license.txt
