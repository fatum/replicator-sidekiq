require 'replicator/producer'
require 'sidekiq'

module Replicator
  class Producer
    class Sidekiq
      class_attribute :worker_classes
      self.worker_classes = {}

      def initialize(collection, consumers)
        @collection, @consumers = collection, consumers
      end

      def call(action, state)
        @consumers.each do |consumer|
          ensure_worker_exists(consumer, @collection)

          ::Sidekiq::Client.
            push(
              'class' => worker_class(consumer),
              'args' => [consumer, action, state],
              'queue' => "replicator-#{@collection}-#{consumer}")
        end
      end

      def ensure_worker_exists(consumer, collection)
        _consumer = consumer_stub(consumer, collection)
        self.worker_classes[consumer] ||= Replicator::Sidekiq::Worker.create(_consumer)
      end

      def worker_class(consumer)
        "Replicator::Sidekiq::Worker#{consumer.to_s.camelcase}".constantize
      end

      def consumer_stub(consumer, collection)
        OpenStruct.new(name: consumer, collection: collection)
      end
    end
  end
end