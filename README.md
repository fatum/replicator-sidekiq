# Replicator::Sidekiq

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'replicator', github: 'fatum/replicator'
    gem 'replicator-sidekiq', github: 'fatum/replicator-sidekiq'

And then execute:

    $ bundle

## Usage

Create comsumer

```ruby
  class DataConsumer
    include Replicator::Consumer::Mixin

    consume :channel do
      name :service
      adapter :sidekiq

      receiver proc { |packet|
        ## handle state changes
      }
    end
  end
```

Listen consumer queue

`bundle exec sidekiq -q replicator-channel-service`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
