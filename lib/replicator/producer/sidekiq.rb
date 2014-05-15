require 'replicator/producer'
require 'sidekiq'

module Replicator
  class Producer
    class Sidekiq
      def initialize(collection, consumers)
        @collection, @consumers = collection, consumers
      end

      def call(action, state)
        @consumers.each do |consumer|
          ::Sidekiq::Client.
            push(
              'class' => "Replicator::Sidekiq::Worker#{consumer.to_s.camelcase}",
              'args' => [consumer, action, state],
              'queue' => "replicator-#{@collection}-#{consumer}")
        end
      end
    end
  end
end